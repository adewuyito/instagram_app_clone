import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/empty_with_text.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/loading_animation_widget.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/features/comments/models/post_comments_request.dart';
import 'package:instagram_app_clone/features/comments/providers/comment_create_provider.dart';
import 'package:instagram_app_clone/features/comments/providers/comment_post_provider.dart';
import 'package:instagram_app_clone/features/comments/views/widget/comment_tile.dart';
import 'package:instagram_app_clone/features/image_upload/views/create_new_post_view.dart';
import 'package:instagram_app_clone/utils/constants/strings.dart';
import 'package:instagram_app_clone/utils/extentions/dismiss_keyboard.dart';

class PostCommentView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentView({required this.postId, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _commentController = useTextEditingController();
    final withText = useState(false);

    final request = useState(
      RequestForPostAndComments(
        postId: postId,
      ),
    );

    final comment = ref.watch(postCommentProvider(request.value));

    useEffect(() {
      _commentController.addListener(() {
        withText.value = _commentController.text.isEmpty;
      });

      return () {};
    }, [_commentController]);

    return Scaffold(
      appBar: AppBar(
        title: Strings.comment.toText,
        actions: [
          IconButton(
            onPressed: withText.value
                ? () {
                    _submitCommentWithController(_commentController, ref);
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comment.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyContentWithTextWidget(
                        text: Strings.noCommentsYet,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(
                        postCommentProvider(request.value),
                      );
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final readComment = comments.elementAt(index);

                          return CommentTile(
                            comment: readComment,
                          );
                        },
                      ),
                    ),
                  );
                },
                error: (_, __) => const ErrorAnimationWidget(),
                loading: () => const LoadingAnimationWidget(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: _commentController,
                    onSubmitted: (comment) {
                      if (comment.isNotEmpty) {
                        _submitCommentWithController(_commentController, ref);
                      }
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Strings.writeYourCommentHere.toText),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);

    if (userId == null) return;

    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );

    if (isSent) {
      controller.clear();
      dismissKeyboard;
    }
  }
}
