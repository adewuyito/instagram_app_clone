import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/comments/extentions/comment_sorting_by_request.dart';
import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/features/comments/models/post_comments_request.dart';
import 'package:instagram_app_clone/utils/constants/firebas_collection_names_constants.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

final postCommentProvider = StreamProvider.family.autoDispose<Iterable<Comment>, RequestForPostAndComments>((
  ref,
  RequestForPostAndComments request,
) {
  final controller = StreamController<Iterable<Comment>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.comments)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .snapshots()
      .listen((snapshot) {
    final doc = snapshot.docs;
    final limitDoc = request.limit != null ? doc.take(request.limit!) : doc;

    final comments = limitDoc
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Comment.fromJson(doc.data(), id: doc.id),
        );

    final result = comments.applySortingFrom(request);
    controller.sink.add(result);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
