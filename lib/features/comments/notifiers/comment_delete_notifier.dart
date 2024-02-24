import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/comment_identifier_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebas_collection_names_constants.dart';

class DeleteCommentStateNotifier extends StateNotifier<IsLoading> {
  DeleteCommentStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteComment({
    required CommentId commentId,
  }) async {
    isLoading = true;
    try {
      // Gets the quary from firestore
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.comments)
          .where(
            FieldPath.documentId,
            isEqualTo: commentId,
          )
          .limit(1)
          .get();

      // gets the data from the query and delete it
      await query.then((data) async {
        for (final doc in data.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
