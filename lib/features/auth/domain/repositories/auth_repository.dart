import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import '../../data/models/my_user.dart';

abstract interface class AuthRepository {
  Future<MyUser> signIn(MyUser user, String password);
  Future<void> changePassword(MyUser user);
  Future<MyUser?> getUser();
  Future<MyUser> signUp(MyUser user, String password);
  Future<void> sendEmailVerification();
  Future<EmailVerificationResult?> checkEmailVerified();
  Future<EmailVerificationResult?> watchEmailVerified();
  Future<void> deleteAccount();
  Future<void> signOut();
}
