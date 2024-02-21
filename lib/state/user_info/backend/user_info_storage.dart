import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_app_clone/state/constants/firebas_collection_names.dart';
import 'package:instagram_app_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_app_clone/state/posts/typedefs/user_id.dart';
import 'package:instagram_app_clone/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) async {
    try {
      // This is a reference to the user's information in the database
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionNames.users,
          )
          .where(
            FirebaseCollectionNames.users,
            isEqualTo: userId,
          )
          .limit(1)
          .get();

      // If the user's information is not found, then we create a new document
      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });

        return true;
      } else {
        final payLoad = UserInfoPayload(
          userId: userId,
          email: email,
          displayName: displayName,
        );
        await FirebaseFirestore.instance
            .collection(
              FirebaseCollectionNames.users,
            )
            .add(
              payLoad,
            );
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
