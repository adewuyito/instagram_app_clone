import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_app_clone/common/typedefs/user_id_typedef.dart';
import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';
import 'package:instagram_app_clone/features/image_upload/models/post_settings_enum.dart';
import 'package:instagram_app_clone/features/posts/models/post_keys.dart';

@immutable
class PostPayload extends MapView<String, dynamic> {
  PostPayload({
    required UserId userId,
    required String message,
    required String thumbnail,
    required String fileUrl,
    required FileType fileType,
    required String fileName,
    required double aspectRatio,
    required String thumbnailStorageId,
    required String originalFileStorageId,
    required Map<PostSetting, bool> postSettings,
  }) : super(
          {
            PostKey.userId: userId,
            PostKey.message: message,
            PostKey.thumbnailUrl: thumbnail,
            PostKey.fileUrl: fileUrl,
            PostKey.filetype: fileType.name,
            PostKey.fileName: fileName,
            PostKey.aspectRatio: aspectRatio,
            PostKey.thumbnailStorageId: thumbnailStorageId,
            PostKey.originalFileStorageId: originalFileStorageId,
            PostKey.postSettings: {
              for (final post in postSettings.entries)
                {
                  post.key.storageKey: postSettings,
                },
            },
            PostKey.createdAt: FieldValue.serverTimestamp(),
          },
        );
}
