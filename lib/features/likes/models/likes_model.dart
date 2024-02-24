import 'dart:collection';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/user_id_typedef.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebase_field_name_constants.dart';

@immutable
class Likes extends MapView<String, String> {
  Likes({
    required PostId postId,
    required UserId userLikedBy,
    required DateTime dateTime,
  }) : super({
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.userId: userLikedBy,
          FirebaseFieldName.createdAt: dateTime.toIso8601String(),
        });
}
