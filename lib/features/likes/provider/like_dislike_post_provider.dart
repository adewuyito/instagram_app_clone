import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/likes/models/like_dislke_request.dart';
import 'package:instagram_app_clone/features/likes/models/likes_model.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

final likeDislikeProvider =
    FutureProvider.family.autoDispose<bool, LikeDislikeRequest>(
  (ref, LikeDislikeRequest likeDislikeRequest) async {
    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.likes)
        .where(FirebaseFieldName.postId, isEqualTo: likeDislikeRequest.postId)
        .where(
          FirebaseFieldName.userId,
          isEqualTo: likeDislikeRequest.userLikedBy,
        )
        .get();

    final hasLikes = await query.then((snapShot) => snapShot.docs.isNotEmpty);

    if (hasLikes) {
      // Delete the like Object
      try {
        await query.then((snaphsot) async {
          for (final doc in snaphsot.docs) {
            doc.reference.delete();
          }
        });
        return true;
      } catch (_) {
        return false;
      }
    } else {
      final newLike = Likes(
        postId: likeDislikeRequest.postId,
        userLikedBy: likeDislikeRequest.userLikedBy,
        dateTime: DateTime.now(),
      );
      try {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.likes)
            .add(newLike);
        return true;
      } catch (_) {
        return false;
      }
    }
  },
);
