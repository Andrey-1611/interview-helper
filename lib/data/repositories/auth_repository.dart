import '../../../../data/models/my_user.dart';

abstract interface class AuthRepository {
  Future<MyUser> signIn(MyUser user, String password);
  Future<void> changePassword(MyUser user);
  Future<MyUser?> getUser();
  Future<MyUser> signUp(MyUser user, String password);
  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerified();
  Future<bool> watchEmailVerified();
  Future<void> deleteAccount();
  Future<void> signOut();
}
