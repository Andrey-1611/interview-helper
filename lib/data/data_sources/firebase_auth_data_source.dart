import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/data/models/user/user_data.dart';
import '../repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class FirebaseAuthDataSource implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<String> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.reload();
      final newUser = _firebaseAuth.currentUser;
      return newUser!.uid;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserData> getUser() async {
    try {
      final user = _firebaseAuth.currentUser!;
      return _fromUser(user);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserData> signUp(String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      await user?.updateDisplayName(name);
      credential.user?.reload();
      final newUser = _firebaseAuth.currentUser;
      return _fromUser(newUser!);
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
  Future<void> changePassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
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

  UserData _fromUser(User user) {
    return UserData(
      id: user.uid,
      name: user.displayName!,
      email: user.email!,
      interviews: [],
    );
  }

  @override
  Future<void> changeEmail(String email, String password) async {
    try {
      final user = (_firebaseAuth.currentUser)!;
      await user.delete();
      _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await user.updateDisplayName(user.displayName);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
