import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/features/comments/notifiers/comment_delete_notifier.dart';

final deleteCommentProvider = StateNotifierProvider<DeleteCommentStateNotifier, IsLoading>(
  (_) => DeleteCommentStateNotifier(),
);
