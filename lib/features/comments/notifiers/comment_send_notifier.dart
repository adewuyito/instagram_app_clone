import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/user_id_typedef.dart';
import 'package:instagram_app_clone/features/comments/models/comment_payload.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';

class SendCommentStateNotifer extends StateNotifier<IsLoading> {
  SendCommentStateNotifer() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> sendComment({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) async {
    isLoading = true;
    final payload = CommentPayload(
      fromUserId: fromUserId,
      postId: onPostId,
      comment: comment,
    );

    try {
      await FirebaseFirestore.instance.collection(FirebaseCollectionNames.comments).add(payload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
