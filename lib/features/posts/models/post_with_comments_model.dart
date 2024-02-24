import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';

@immutable
class PostWithComment {
  final Post post;
  final Iterable<Comment> comments;

  const PostWithComment({
    required this.comments,
    required this.post,
  });

  @override
  bool operator ==(covariant PostWithComment other) =>
      post == other.post &&
      const IterableEquality().equals(comments, other.comments);

  @override
  int get hashCode => Object.hashAll([post, comments]);
}
