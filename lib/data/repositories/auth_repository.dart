import 'package:interview_master/data/models/user/user_data.dart';

abstract interface class AuthRepository {
  Future<String> signIn(String email, String password);

  Future<UserData> signInWithGoogle();

  Future<void> changePassword(String email);

  Future<void> changeEmail(String email, String password);

  Future<UserData> getUser();

  Future<UserData> signUp(String name, String email, String password);

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  Future<bool> watchEmailVerified();

  Future<void> deleteAccount();

  Future<void> signOut();
}
