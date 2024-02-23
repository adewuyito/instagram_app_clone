import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/features/comments/notifiers/comment_send_notifier.dart';

final sendCommentProvider = StateNotifierProvider<SendCommentStateNotifer, IsLoading>((_) => SendCommentStateNotifer());