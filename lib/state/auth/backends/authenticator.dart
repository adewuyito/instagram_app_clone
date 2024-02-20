import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app_clone/state/posts/typedefs/user_id.dart';


class Authenticator {
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
}