import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<UserProfile> signIn(UserProfile userProfile, String password) async {
    return await _authDataSource.signIn(userProfile, password);
  }

  @override
  Future<void> changePassword(UserProfile userProfile) async {
    await _authDataSource.changePassword(userProfile);
  }

  @override
  Future<EmailVerificationResult?> checkEmailVerified() async {
    return await _authDataSource.checkEmailVerified();
  }

  @override
  Future<void> deleteAccount() async {
    await _authDataSource.deleteAccount();
  }

  @override
  Future<void> sendEmailVerification() async {
    await _authDataSource.sendEmailVerification();
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  Future<UserProfile> signUp(UserProfile userProfile, String password) async {
    return await _authDataSource.signUp(userProfile, password);
  }

  @override
  Future<EmailVerificationResult?> watchEmailVerified() async {
    return await _authDataSource.watchEmailVerified();
  }
}
