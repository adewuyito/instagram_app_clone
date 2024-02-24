import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebase_field_name_constants.dart';

final postLikesCountProvider = StreamProvider.autoDispose.family<int, PostId>((
  ref,
  PostId postId,
) {
  final controller = StreamController<int>.broadcast();

  controller.onListen = () {
    controller.sink.add(0);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.likes)
      .where(FirebaseFieldName.postId, isEqualTo: postId)
      .snapshots()
      .listen(
    (snapshot) {
      controller.sink.add(
        snapshot.docs.length,
      );
    },
  );

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
