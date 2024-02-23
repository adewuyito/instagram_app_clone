import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/auth_state_provider.dart';
import 'package:instagram_app_clone/features/image_upload/provider/image_upload_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploading = ref.watch(imageUploadProvider);

  return authState.isLoading || isUploading;
});
