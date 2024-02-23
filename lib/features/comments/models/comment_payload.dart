import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required String fromUserId,
    required PostId postId,
    required String comment,
  }) : super({
          FirebaseFieldName.userId: fromUserId,
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.comment: comment,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        });
}
