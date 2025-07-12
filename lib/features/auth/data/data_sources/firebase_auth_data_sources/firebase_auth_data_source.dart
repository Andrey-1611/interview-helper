import 'dart:developer';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/features/auth/data/models/user_profile.dart';

class FirebaseAuthDataSource implements FirebaseAuthDataSourceInterface {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserProfile> signIn(UserProfile userProfile, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: userProfile.email,
        password: password,
      );
      final user = _toUserProfile(credential.user!);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserProfile> signUp(UserProfile userProfile, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userProfile.email,
        password: password,
      );
      await credential.user?.updateDisplayName(userProfile.name);
      await credential.user?.reload();
      final user = _toUserProfile(credential.user!);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserProfile?> checkCurrentUser() async {
    await _firebaseAuth.currentUser?.reload();
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final userProfile = _toUserProfile(currentUser);
      return userProfile;
    }
    return null;
  }

  UserProfile _toUserProfile(User user) {
    return UserProfile(id: user.uid, name: user.displayName ?? '', email: user.email ?? '');
  }
}
