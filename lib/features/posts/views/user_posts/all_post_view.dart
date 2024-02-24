import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/empty_with_text.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/loading_animation_widget.dart';
import 'package:instagram_app_clone/features/posts/provider/all_posts_provider.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/strings.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_grid_widget.dart';

class AllPostView extends ConsumerWidget {
  const AllPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPost = ref.watch(allPostProvider);
    return RefreshIndicator(
      onRefresh: () async {
        // ignore: unused_result
        ref.refresh(allPostProvider);
        Future.delayed(const Duration(seconds: 1));
      },
      child: allPost.when(
        data: (post) {
          if (post.isEmpty) {
            return const EmptyContentWithTextWidget(
              text: Strings.noPostsAvailable,
            );
          }
          return PostGridViewWidget(posts: post);
        },
        error: (_, __) => const ErrorAnimationWidget(),
        loading: () => const LoadingAnimationWidget(),
      ),
    );
  }
}
