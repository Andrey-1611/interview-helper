import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import '../../../../app/global_services/user/models/my_user.dart';


class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<MyUser> signIn(MyUser user, String password) async {
    return await _authDataSource.signIn(user, password);
  }

  @override
  Future<void> changePassword(MyUser user) async {
    await _authDataSource.changePassword(user);
  }

  @override
  Future<MyUser?> getUser() async {
    return await _authDataSource.getUser();
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
  Future<MyUser> signUp(MyUser user, String password) async {
    return await _authDataSource.signUp(user, password);
  }

  @override
  Future<EmailVerificationResult?> watchEmailVerified() async {
    return await _authDataSource.watchEmailVerified();
  }
}
