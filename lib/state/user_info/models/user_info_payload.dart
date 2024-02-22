import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_app_clone/features/posts/typedefs/user_id.dart';
import 'package:instagram_app_clone/utils/constants/firebase_field_name_constants.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  // This is a method that would be used to create a new instance of the [UserInfoPayload]
  // with the new values serialized into the map
  UserInfoPayload({
    required UserId userId,
    required String? email,
    required String? displayName,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.email: email ?? '',
          FirebaseFieldName.displayName: displayName ?? '',
        });

  
}
