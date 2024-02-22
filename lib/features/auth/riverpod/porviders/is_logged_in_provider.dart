import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/models/auth_result.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/auth_state_provider.dart';

/// Provider to check if the user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});
