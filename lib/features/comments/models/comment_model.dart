import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_app_clone/common/typedefs/comment_identifier_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/user_id_typedef.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUid;
  final PostId postId;

  Comment.fromJson(Map<String, dynamic> json, {required this.id})
      : comment = json[FirebaseFieldName.comment],
        createdAt = ((json[FirebaseFieldName.createdAt]) as Timestamp).toDate(),
        fromUid = json[FirebaseFieldName.userId],
        postId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          fromUid == other.fromUid &&
          postId == other.postId;

  @override
  int get hashCode => Object.hashAll([id, comment, createdAt, fromUid, postId]);
}
