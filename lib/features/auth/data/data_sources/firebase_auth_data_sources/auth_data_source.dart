import 'dart:developer';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

import '../../../../../core/exceptions/auth_exception.dart';

class AuthDataSource implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthDataSource({FirebaseAuth? firebaseAuth})
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
      final updatedUser = _firebaseAuth.currentUser!;
      final user = _toUserProfile(updatedUser);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Аккаунт с такой почтой не найден');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Неверный пароль');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Некорректная почта');
      } else {
        throw AuthException('Ошибка входа');
      }
    } catch (e) {
      throw AuthException('Произошла неизвестная ошибка');
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
    return UserProfile(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
