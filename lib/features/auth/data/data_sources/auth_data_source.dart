import 'dart:async';
import 'dart:developer';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthDataSource(this._firebaseAuth);

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

  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<EmailVerificationResult?> checkEmailVerified() async {
    try {
      final user = _firebaseAuth.currentUser;
      final bool isEmailVerified = user!.emailVerified;
      final UserProfile userProfile = _toUserProfile(user);
      return EmailVerificationResult(
        isEmailVerified: isEmailVerified,
        userProfile: userProfile,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<EmailVerificationResult?> watchEmailVerified() async {
    try {
      User? user = _firebaseAuth.currentUser;
      while (!user!.emailVerified) {
        await user.reload();
        user = _firebaseAuth.currentUser;
        await Future.delayed(const Duration(seconds: 3));
      }
      return EmailVerificationResult(
        isEmailVerified: true,
        userProfile: _toUserProfile(user),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> changePassword(UserProfile userProfile) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: userProfile.email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
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
