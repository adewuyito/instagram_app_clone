import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import 'package:instagram_app_clone/features/image_upload/extentions/get_collection_name_from_types.dart';
import 'package:instagram_app_clone/features/posts/models/post_payload.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';
import 'package:uuid/uuid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/user_id_typedef.dart';
import 'package:instagram_app_clone/features/image_upload/exceptions/image_exceptions.dart';
import 'package:instagram_app_clone/features/image_upload/extentions/get_image_data_aspect_ratio.dart';
import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';
import 'package:instagram_app_clone/features/image_upload/models/post_settings_enum.dart';
import 'package:instagram_app_clone/utils/constants/file_upload_constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;
    late Uint8List thumbNailUint8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        // Create the ThumbNail
        final thumbnail = img.copyResize(fileAsImage, width: FileUploadConstants.imageThumbNailWidth);
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbNailUint8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: FileUploadConstants.videoThumbNailMaxiHight,
          quality: FileUploadConstants.videoThumbNailQuality,
        );
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        thumbNailUint8List = Uint8List.fromList(thumb);
        break;
    }

    // Calculate the aspect ratio
    final thumbnailAspectRatio = await thumbNailUint8List.getAspectRatio;

    // Calculate refrences
    final fileName = const Uuid().v4();

    // Create refrences to the thumbnail and image

    final thumbnailRef = FirebaseStorage.instance.ref().child(userId).child(FirebaseCollectionNames.thumbNails).child(fileName);

    final originalFileRef = FirebaseStorage.instance.ref().child(userId).child(fileType.collectionName).child(fileName);

    try {
      // Uplod thethumbnail
      final thumbnailUploadtask = await thumbnailRef.putData(thumbNailUint8List);
      final thumbnailStorageId = thumbnailUploadtask.ref.name;

      // Upload Original file
      final originalFileUplpadtask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUplpadtask.ref.name;

      // Upload post
      final postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnail: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );

      await FirebaseFirestore.instance.collection(FirebaseCollectionNames.posts).add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
