import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/models/post_keys.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

// This provider is used to get the posts of the current user
final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final userId = ref.watch(userIdProvider);

  // Used to manage the stream
  final controller = StreamController<Iterable<Post>>();

  controller.onListen = () {
    controller.add([]);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .where(PostKey.userId, isEqualTo: userId)
      .snapshots()
      .listen(
    (snapshot) {
      final document = snapshot.docs;
      // Check if the document has pending writes
      // If it has pending writes, it means the data is not yet available
      // So we don't want to add it to the stream
      final posts = document
          .where(
            (doc) => !doc.metadata.hasPendingWrites,
          )
          .map(
            (doc) => Post(json: doc.data(), postId: doc.id),
          );
      controller.sink.add(posts);
    },
  );


  // Dispose the stream
  // This is called when the stream is no longer needed
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
