import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

final hasLikedPostProvider = StreamProvider.autoDispose.family<bool, PostId>(
  (
    ref,
    postId,
  ) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return Stream<bool>.value(false);
    }
    final controller = StreamController<bool>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.likes)
        .where(FirebaseFieldName.postId, isEqualTo: postId)
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          controller.add(true);
        } else {
          controller.add(false);
        }
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
