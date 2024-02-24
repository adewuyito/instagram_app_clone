import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/auth_state_provider.dart';
import 'package:instagram_app_clone/features/comments/providers/comment_create_provider.dart';
import 'package:instagram_app_clone/features/comments/providers/comment_delete_provider.dart';
import 'package:instagram_app_clone/features/image_upload/provider/image_upload_provider.dart';
import 'package:instagram_app_clone/features/posts/provider/post_delete_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploading = ref.watch(imageUploadProvider);
  final isSendingComment = ref.watch(sendCommentProvider);
  final isDeletingComment = ref.watch(deleteCommentProvider);
  final isDeletingPost = ref.watch(deletePostProvider);

  return authState.isLoading ||
      isUploading ||
      isSendingComment ||
      isDeletingComment ||
      isDeletingPost;
});
