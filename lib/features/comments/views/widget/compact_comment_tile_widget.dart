import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/rich_text/rich_two_part_text.dart';
import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/state/user_info/providers/user_info_model_provider.dart';

class CompactCommentTile extends ConsumerWidget {
  final Comment comment;
  const CompactCommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoModelProvider(comment.fromUid));
    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartText(
          firstPart: userInfo.displayName,
          secondPart: comment.comment,
        );
      },
      error: (_, __) => const SmallErrorAnimationWidget(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
