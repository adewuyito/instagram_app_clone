import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/dialog/model/alert_dialog.dart';
import 'package:instagram_app_clone/common/components/dialog/view/delete_dialog.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/features/comments/providers/comment_delete_provider.dart';
import 'package:instagram_app_clone/features/image_upload/views/create_new_post_view.dart';
import 'package:instagram_app_clone/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/strings.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({required this.comment, super.key});

  Future<bool> displayDeleteDialog(BuildContext context) => const DeleteDialog(titleOfObjectToDelete: Strings.comment)
      .present(
        context,
      )
      .then((value) => value ?? false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.fromUid,
      ),
    );
    return userInfo.when(
      data: (userInfo) {
        final isCurrentUser = identical(comment.fromUid, ref.read(userIdProvider));
        return ListTile(
          trailing: isCurrentUser
              ? IconButton(
                  onPressed: () async {
                    final shouldDeleteComment = await displayDeleteDialog(context);
                    
                    if (shouldDeleteComment) {
                      await ref.read(deleteCommentProvider.notifier).deleteComment(commentId: comment.id);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                )
              : null,
          title: userInfo.displayName.toText,
          subtitle: comment.comment.toText,
        );
      },
      error: (_, __) => const SmallErrorAnimationWidget(),
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
