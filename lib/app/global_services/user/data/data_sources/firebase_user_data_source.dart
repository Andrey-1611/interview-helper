import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/my_user.dart';

class FirebaseUserDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseUserDataSource(this._firebaseAuth);

  Future<MyUser?> getUser() async {
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

  MyUser _toUserProfile(User user) {
    return MyUser(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
