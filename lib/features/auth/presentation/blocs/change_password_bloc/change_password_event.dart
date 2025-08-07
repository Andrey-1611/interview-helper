part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ChangePassword extends ChangePasswordEvent {
  final MyUser user;

  const ChangePassword({required this.user});

  @override
  List<Object?> get props => [user];
}