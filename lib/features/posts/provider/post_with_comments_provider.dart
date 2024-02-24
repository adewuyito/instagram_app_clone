import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/comments/extentions/comment_sorting_by_request.dart';
import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/models/post_comments_request.dart';
import 'package:instagram_app_clone/features/posts/models/post_with_comments_model.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

final postWithCommentProvider = StreamProvider.family
    .autoDispose<PostWithComment, RequestForPostAndComments>(
  (
    ref,
    request,
  ) {
    final controller = StreamController<PostWithComment>();

    Post? post;
    Iterable<Comment>? comments;

    // Function to make sure that both the post and comment
    // are present before a post is added to the stream
    void notify() {
      final localPost = post;
      if (localPost == null) {
        return;
      }

      final outputComment = (comments ?? []).applySortingFrom(request);

      final result = PostWithComment(
        comments: outputComment,
        post: localPost,
      );

      controller.sink.add(result);
    }

    final postSub = FirebaseFirestore.instance
        .collection(FirebaseFieldName.postId)
        .where(FieldPath.documentId, isEqualTo: request.postId)
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          post = null;
          comments = null;
          notify();
          return;
        }
        final doc = snapshot.docs.first;
        if (doc.metadata.hasPendingWrites) {
          return;
        }
        post = Post(
          postId: doc.id,
          json: doc.data(),
        );
        notify();
      },
    );

    final commentQuery = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.comments)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .orderBy(FirebaseFieldName.createdAt, descending: true);

    final limitedCommentsQuery = request.limit != null
        ? commentQuery.limit(request.limit!)
        : commentQuery;

    final commentSub = limitedCommentsQuery.snapshots().listen(
      (snapshot) {
        comments = snapshot.docs
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Comment.fromJson(
                id: doc.id,
                doc.data(),
              ),
            )
            .toList();
        notify();
      },
    );

    ref.onDispose(() {
      commentSub.cancel();
      postSub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
