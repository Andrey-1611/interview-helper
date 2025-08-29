import 'package:equatable/equatable.dart';

import 'my_user.dart';

class EmailVerificationResult extends Equatable {
  final bool isEmailVerified;
  final MyUser? user;

  const EmailVerificationResult({
    required this.isEmailVerified,
    required this.user,
  });

  @override
  List<Object?> get props => [isEmailVerified, user];
}
