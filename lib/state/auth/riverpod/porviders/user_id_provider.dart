import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/state/auth/riverpod/porviders/auth_state_provider.dart';
import 'package:instagram_app_clone/state/posts/typedefs/user_id.dart';

final userIdProvider = Provider<UserId?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.userId;
});