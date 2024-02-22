import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_app_clone/features/auth/models/constants/constants.dart';
import 'package:instagram_app_clone/features/auth/models/auth_result.dart';
import 'package:instagram_app_clone/features/posts/typedefs/user_id.dart';

class Authenticator {
  const Authenticator();

  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName => FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    // Sign out of all possible account forms
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final lR = await FacebookAuth.instance.login();
    final token = lR.accessToken?.token;

    if (token == null) {
      return AuthResult.aborted;
    }

    final oauthCredential = FacebookAuthProvider.credential(token);

    try {
      await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;

      if (e.code == AuthConstants.accountsExistWithDifferentCredential && email != null && credential != null) {
        // TODO: Get the solution to this
        // ignore: deprecated_member_use
        final provider = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (provider.contains(AuthConstants.googleCom)) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    // Signing in with google credentials
    final googleSignIn = GoogleSignIn(scopes: [AuthConstants.emailScope]);
    final signInAccount = await googleSignIn.signIn();

    // On error or termination of Signin
    if (signInAccount == null) {
      return AuthResult.failure;
    }

    final googleAuth = await signInAccount.authentication;
    final oauthCredential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // Passing to firebase
    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
