import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/firebase_field_name_constants.dart';

final allPostProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.posts)
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final allPost = snapshot.docs.map(
          (post) => Post(
            postId: post.id,
            json: post.data(),
          ),
        );
        controller.sink.add(allPost);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
