import 'package:flutter/material.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/views/post_details/post__details_view.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_thumbnail_widget.dart';

class PostGridViewWidget extends StatelessWidget {
  final Iterable<Post> posts;

  const PostGridViewWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
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
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
    );
  }
}
