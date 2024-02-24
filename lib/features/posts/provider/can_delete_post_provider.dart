import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';

final canCurrentUserDeletePostProvider =
    StreamProvider.family.autoDispose<bool, Post>((
  ref,
  Post post,
) async* {
  // WHEN A STREAM IS MARKED AN ASYNC GENERATOR {async*}
  //  THE YIELD FUNCTION IS PRESENT TO YOU TO YIELD THE ENTIRE STREAM

  final userId = ref.watch(userIdProvider);

  // THIS WOULD ADD TRUE TO THE STREAM WITHOUT THE NEED FOR A STREAM CONTROLLER
  yield userId == post.userId;
});
