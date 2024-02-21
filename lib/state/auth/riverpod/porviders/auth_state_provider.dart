import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/state/auth/models/auth_state.dart';
import 'package:instagram_app_clone/state/auth/riverpod/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
