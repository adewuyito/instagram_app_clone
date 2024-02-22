import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/auth/backends/authenticator.dart';
import 'package:instagram_app_clone/features/auth/models/auth_result.dart';
import 'package:instagram_app_clone/features/auth/models/auth_state.dart';
import 'package:instagram_app_clone/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  // A constructor to get the state of AuthState on reading of riverPod
  // if the state gets a logged in query back the state would change to
  // an AuthState having its logged in state a successfull and the loading tag set to false.
  /// Constructor for [AuthStateNotifier]
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  /// Provider created to use riverpod for logout
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);

    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await _saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> loginWithFaceBook() async {
    state = state.copiedWithIsLoading(true);

    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await _saveUserInfo(userId: userId);
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> _saveUserInfo({
    required userId,
  }) {
    return _userInfoStorage.saveUserInfo(
      userId: userId,
      displayName: _authenticator.displayName,
      email: _authenticator.email,
    );
  }
}
