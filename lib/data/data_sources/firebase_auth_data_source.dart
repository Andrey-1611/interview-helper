import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../models/my_user.dart';
import '../repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class FirebaseAuthDataSource implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
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

  @override
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

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );
      await credential.user?.updateDisplayName(myUser.name);
      await credential.user?.reload();
      final updatedUser = _firebaseAuth.currentUser;
      final user = _toUserProfile(updatedUser!);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
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

  @override
  Future<bool> checkEmailVerified() async {
    try {
      return _firebaseAuth.currentUser!.emailVerified;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> watchEmailVerified() async {
    try {
      User? user = _firebaseAuth.currentUser;
      while (!user!.emailVerified) {
        await user.reload();
        user = _firebaseAuth.currentUser;
        await Future.delayed(const Duration(seconds: 1));
      }
      return true;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> changePassword(MyUser myUser) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: myUser.email);
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
