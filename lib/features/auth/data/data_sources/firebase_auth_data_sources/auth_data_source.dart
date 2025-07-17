import 'dart:developer';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

class AuthDataSource implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthDataSource({required this.firebaseAuth});

  @override
  Future<UserProfile> signIn(UserProfile userProfile, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
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
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: userProfile.email,
        password: password,
      );
      await credential.user?.updateDisplayName(userProfile.name);
      await credential.user?.reload();
      final updatedUser = firebaseAuth.currentUser!;
      final user = _toUserProfile(updatedUser);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<EmailVerificationResult?> isEmailVerified() async {
    try {
      final user = firebaseAuth.currentUser;
      await user?.reload();
      if (user == null) return null;
      final bool isEmailVerified = user.emailVerified;
      final UserProfile userProfile = UserProfile(
        id: user.uid,
        name: user.displayName,
        email: user.email!,
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
  Future<UserProfile?> checkCurrentUser() async {
    try {
      await firebaseAuth.currentUser?.reload();
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        final userProfile = _toUserProfile(currentUser);
        return userProfile;
      }
      return null;
    }  catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
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
