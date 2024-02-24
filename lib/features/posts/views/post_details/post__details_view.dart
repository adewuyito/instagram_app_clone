import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/loading_animation_widget.dart';
import 'package:instagram_app_clone/common/components/dialog/model/alert_dialog.dart';
import 'package:instagram_app_clone/common/components/dialog/view/delete_dialog.dart';
import 'package:instagram_app_clone/features/comments/views/comment_view.dart';
import 'package:instagram_app_clone/features/comments/views/widget/compact_comment_column_widget.dart';
import 'package:instagram_app_clone/features/likes/views/likes_count_widget.dart';
import 'package:instagram_app_clone/features/likes/views/widget/like_button.dart';
import 'package:instagram_app_clone/features/posts/provider/post_delete_provider.dart';
import 'package:instagram_app_clone/features/posts/views/user_posts/post_image_or_video_view.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_date_widget.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_display_name_and_message.dart';
import 'package:share_plus/share_plus.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
import 'package:instagram_app_clone/features/image_upload/views/create_new_post_view.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:instagram_app_clone/features/posts/models/post_comments_request.dart';
import 'package:instagram_app_clone/features/posts/provider/can_delete_post_provider.dart';
import 'package:instagram_app_clone/features/posts/provider/post_with_comments_provider.dart';
import 'package:instagram_app_clone/utils/constants/strings.dart';
import 'package:instagram_app_clone/utils/enums/date_sorting.dart';

class PostDetailView extends ConsumerStatefulWidget {
  // TODO: FIX TO HAVING THE POST ID
  final Post post;
  const PostDetailView({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    final postWithComment = ref.watch(postWithCommentProvider(request));

    final shouldDeletePost = ref
        .watch(
          canCurrentUserDeletePostProvider(widget.post),
        )
        .value;

    return Scaffold(
      appBar: AppBar(
        title: Strings.postDetails.toText,
        actions: [
          // Share button
          postWithComment.when(
            data: (postWithComment) {
              return IconButton(
                onPressed: () {
                  final url = postWithComment.post.fileUrl;
                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                },
                icon: const Icon(Icons.share),
              );
            },
            error: (_, __) => const SmallErrorAnimationWidget(),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          // Delete button
          if (shouldDeletePost ?? false)
            IconButton(
              onPressed: () async {
                // SHOW DELETE CONFIRMATION DIALOGE
                final shouldDeletePost = await const DeleteDialog(
                        titleOfObjectToDelete: Strings.post)
                    .present(context)
                    .then((shouldDelete) => shouldDelete ?? false);

                // Delete the post if the user taps yes
                shouldDeletePost
                    ? await ref
                        .read(deletePostProvider.notifier)
                        .deletePost(post: widget.post)
                    : null;

                mounted ? Navigator.of(context).pop() : null;
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: postWithComment.when(
        data: (gottenPost) {
          final postId = gottenPost.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(post: gottenPost.post),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Like Button is allowed
                    if (gottenPost.post.allowedLikes)
                      LikeBottun(postId: postId),

                    // Comment Button if post allows comment
                    if (gottenPost.post.allowedComments)
                      IconButton(
                        icon: const Icon(Icons.mode_comment_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostCommentView(postId: postId),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                // POST DETAILS
                PostDisplayNameAndMessage(post: gottenPost.post),
                //
                PostDate(postDateTime: gottenPost.post.createdAt),
                // Divider
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
                // Compact Comment
                CompactCommentColumnWidget(comments: gottenPost.comments),
                // Like counter
                if (gottenPost.post.allowedLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountViews(postId: postId),
                      ],
                    ),
                  ),
                // Add spacing
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        },
        error: (_, __) => const ErrorAnimationWidget(),
        loading: () => const LoadingAnimationWidget(),
      ),
    );
  }
}
