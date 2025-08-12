import '../../../../app/global_services/user/models/my_user.dart';

class EmailVerificationResult {
  final bool isEmailVerified;
  final MyUser? user;

  EmailVerificationResult({
    required this.isEmailVerified,
    required this.user,
  });
}
