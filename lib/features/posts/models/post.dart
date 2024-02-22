import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';
import 'package:instagram_app_clone/features/image_upload/models/post_settings_enum.dart';
import 'package:instagram_app_clone/features/posts/models/post_keys.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final String thumbnailUrl;
  final String fileUrl;
  final FileType filetype;
  final String fileName;
  final double aspectRatio;
  final Map<PostSetting, bool> postSettings;
  final String thumbnailStorageId;
  final String originalFileStorageId;

  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        message = json[PostKey.message],
        createdAt = ((json[PostKey.createdAt]) as Timestamp).toDate(),
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        filetype = FileType.values.firstWhere(
          (ft) => ft.name == json[PostKey.filetype],
          orElse: () => FileType.image,
        ),
        fileName = json[PostKey.fileName],
        aspectRatio = json[PostKey.aspectRatio],
        postSettings = {
          for (final entry in json[PostKey.postSettings].entries)
            PostSetting.values.firstWhere(
              (ps) => ps.name == entry.key,
            ): entry.value
        },
        thumbnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId];


        bool get allowedLikes => postSettings[PostSetting.allowLikes] ?? false;
        bool get allowedComments => postSettings[PostSetting.allowComments] ?? false;
}
