import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/image_upload/exceptions/image_exceptions.dart';
import 'package:instagram_app_clone/features/image_upload/extentions/get_image_aspect_ratio.dart';
import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';
import 'package:instagram_app_clone/features/image_upload/models/image_with_aspect_ratio.dart';
import 'package:instagram_app_clone/features/image_upload/models/thumbnail_request.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final thumbnailProvider = FutureProvider.family.autoDispose<ImageWithAspectRatio, ThumbNailRequest>(
  (
    ref,
    request,
  ) async {
    final Image image;

    switch (request.fileType) {
      // Getting the aspect ratio from an image file
      case FileType.image:
        image = Image.file(
          request.file,
          fit: BoxFit.fitHeight,
        );
        break;
      // getting the aspect ratio from a video file by first getting the thumb nail
      // of the video
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(video: request.file.path, imageFormat: ImageFormat.JPEG, quality: 75);
        if (thumb == null) throw const CouldNotBuildThumbnailException();
        image = Image.memory(
          thumb,
          fit: BoxFit.fitHeight,
        );
        break;
    }
    final aspectRatio = await image.getAspectRatio;
    return ImageWithAspectRatio(image: image, aspectRatio: aspectRatio);
  },
);
