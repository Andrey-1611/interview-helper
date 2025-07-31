part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ChangePassword extends ChangePasswordEvent {
  final UserProfile userProfile;

  const ChangePassword({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}