import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/auth_state_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.isLoading;
});
