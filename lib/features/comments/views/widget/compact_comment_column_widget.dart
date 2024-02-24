import 'package:flutter/material.dart';
import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/features/comments/views/widget/compact_comment_tile_widget.dart';

class CompactCommentColumnWidget extends StatelessWidget {
  final Iterable<Comment> comments;
  const CompactCommentColumnWidget({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments.map((commentItem) => CompactCommentTile(comment: commentItem)).toList(),
        )
      );
    }
  }
}


// Personal build version for the comment view
// ListView.builder(
//           itemCount: comments.length,
//           itemBuilder: (context, index) {
//             final commentIndxedAt = comments.elementAt(index);
//             return CompactCommentTile(comment: commentIndxedAt);
//           },
//         ),
