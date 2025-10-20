import 'dart:async';
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
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.reload();
    final newUser = _firebaseAuth.currentUser;
    return newUser!.uid;
  }

  @override
  Future<UserData> getUser() async {
    final user = _firebaseAuth.currentUser!;
    return _fromUser(user);
  }

  @override
  Future<UserData> signUp(String name, String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    await user?.updateDisplayName(name);
    credential.user?.reload();
    final newUser = _firebaseAuth.currentUser;
    return _fromUser(newUser!);
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    return _firebaseAuth.currentUser!.emailVerified;
  }

  @override
  Future<bool> watchEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    while (!user!.emailVerified) {
      await user.reload();
      user = _firebaseAuth.currentUser;
      await Future.delayed(const Duration(seconds: 1));
    }
    return true;
  }

  @override
  Future<void> changePassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser?.delete();
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
    final user = (_firebaseAuth.currentUser)!;
    await user.delete();
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await user.updateDisplayName(user.displayName);
  }
}
