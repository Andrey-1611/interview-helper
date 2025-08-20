import 'my_user.dart';

class EmailVerificationResult {
  final bool isEmailVerified;
  final MyUser? user;

  EmailVerificationResult({
    required this.isEmailVerified,
    required this.user,
  });
}
