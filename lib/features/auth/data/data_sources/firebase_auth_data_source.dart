import 'dart:async';
import 'dart:developer';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/global_services/user/data/models/my_user.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Future<MyUser> signIn(MyUser myUser, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );
      final user = _toUserProfile(credential.user!);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );
      await credential.user?.updateDisplayName(myUser.name);
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
      final MyUser userProfile = _toUserProfile(user);
      return EmailVerificationResult(
        isEmailVerified: isEmailVerified,
        user: userProfile,
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
        user: _toUserProfile(user),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> changePassword(MyUser myUser) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: myUser.email);
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

  MyUser _toUserProfile(User user) {
    return MyUser(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
