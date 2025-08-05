import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

class UserService implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserService(this._firebaseAuth);

  @override
  Future<UserProfile?> getUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final userProfile = _toUserProfile(user);
        return userProfile;
      }
      return null;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  UserProfile _toUserProfile(User user) {
    return UserProfile(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
