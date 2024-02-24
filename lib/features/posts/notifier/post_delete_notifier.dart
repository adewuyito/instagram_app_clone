import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/features/image_upload/extentions/get_collection_name_from_types.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebase_field_name_constants.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deletePost({required Post post}) async {
    isLoading = true;

    try {
      // Delete the thubmbnail
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionNames.thumbNails)
          .child(post.thumbnailStorageId)
          .delete();

      // Delete the original file
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.filetype.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      // Delete all comments
      await _deleteAllDocument(
        postId: post.postId,
        inCollection: FirebaseCollectionNames.comments,
      );

      // Delete all likes
      await _deleteAllDocument(
        postId: post.postId,
        inCollection: FirebaseCollectionNames.likes,
      );

      // Delete the post
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.posts)
          .where(FieldPath.documentId, isEqualTo: post.postId)
          .get();

      for (final doc in postInCollection.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocument({
    required PostId postId,
    required String inCollection,
  }) {
    return FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(FirebaseFieldName.postId, isEqualTo: postId)
            .get();

        for (final docs in query.docs) {
          transaction.delete(docs.reference);
        }
      },
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
    );
  }
}
