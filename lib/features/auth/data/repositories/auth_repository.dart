import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';

abstract interface class AuthRepository {
  Future<UserProfile> signIn(UserProfile userProfile, String password);
  Future<UserProfile> signUp(UserProfile userProfile, String password);
  Future<void> sendEmailVerification();
  Future<EmailVerificationResult?> isEmailVerified();
  Future<void> changeEmail(UserProfile userProfile);
  Future<void> changePassword(UserProfile userProfile);
  Future<UserProfile?> checkCurrentUser();
  Future<void> signOut();
}
