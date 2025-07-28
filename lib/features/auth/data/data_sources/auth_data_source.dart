import 'dart:developer';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

class AuthDataSource implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthDataSource(this._firebaseAuth);

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
  Future<UserProfile> signUp(UserProfile userProfile, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userProfile.email,
        password: password,
      );
      await credential.user?.updateDisplayName(userProfile.name);
      await credential.user?.reload();
      final updatedUser = _firebaseAuth.currentUser!;
      final user = _toUserProfile(updatedUser);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<EmailVerificationResult?> isEmailVerified() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.reload();
      final newUser = _firebaseAuth.currentUser;
      if (newUser == null) return null;
      final bool isEmailVerified = newUser.emailVerified;
      final UserProfile userProfile = UserProfile(
        id: newUser.uid,
        name: newUser.displayName,
        email: newUser.email!,
      );
      return EmailVerificationResult(
        isEmailVerified: isEmailVerified,
        userProfile: userProfile,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> changeEmail(UserProfile userProfile) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.verifyBeforeUpdateEmail(userProfile.email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> changePassword(String password) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.updatePassword(password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserProfile?> checkCurrentUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final userProfile = _toUserProfile(currentUser);
        return userProfile;
      }
      return null;
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

  UserProfile _toUserProfile(User user) {
    return UserProfile(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
