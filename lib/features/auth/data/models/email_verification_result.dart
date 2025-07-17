import 'package:interview_master/core/global_services/user/models/user_profile.dart';

class EmailVerificationResult {
  final bool isEmailVerified;
  final UserProfile userProfile;

  EmailVerificationResult({
    required this.isEmailVerified,
    required this.userProfile,
  });
}
