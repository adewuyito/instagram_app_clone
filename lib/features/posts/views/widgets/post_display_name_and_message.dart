import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/rich_text/rich_two_part_text.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/state/user_info/providers/user_info_model_provider.dart';

class PostDisplayNameAndMMessage extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMMessage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoModelProvider(post.userId));
    return userInfo.when(
      data: (userPostInfo) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichTwoPartText(firstPart: userPostInfo.displayName, secondPart: post.message),
        );
      },
      error: (_, __) => const SmallErrorAnimationWidget(),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
