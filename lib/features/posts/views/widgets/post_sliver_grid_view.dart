import 'package:flutter/material.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/views/post_details/post__details_view.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_thumbnail_widget.dart';

class PostSliverGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostSliverGridView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailWidget(
          post: post,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PostDetailView(post: post),
              ),
            );
          },
        );
      }),
    );
  }
}
