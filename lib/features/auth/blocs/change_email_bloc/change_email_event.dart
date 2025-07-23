part of 'change_email_bloc.dart';

sealed class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object?> get props => [];
}

final class ChangeEmail extends ChangeEmailEvent {
  final UserProfile userProfile;

  const ChangeEmail({required this.userProfile,});

  @override
  List<Object?> get props => [userProfile];
}