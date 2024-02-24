import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/empty_with_text.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/loading_animation_widget.dart';
import 'package:instagram_app_clone/features/posts/provider/user_post_providers.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_grid_widget.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/strings.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(userPostsProvider);
    return RefreshIndicator.adaptive(
      child: post.when(
        data: (data) {
          if (data.isEmpty) {
            return const EmptyContentWithTextWidget(text: Strings.youHaveNoPosts);
          } else {
            return PostGridViewWidget(posts: data);
          }
        },
        error: (error, stackTrace) => const ErrorAnimationWidget(),
        loading: () => const LoadingAnimationWidget(),
      ),
      onRefresh: () async {
        // Simulate network delay
        Future.delayed(const Duration(seconds: 1));
        // ignore: unused_result
        return ref.refresh(userPostsProvider);
      },
    );
  }
}
