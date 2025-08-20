part of 'change_email_bloc.dart';

sealed class ChangeEmailState extends Equatable {
  const ChangeEmailState();

  @override
  List<Object> get props => [];
}

final class ChangeEmailInitial extends ChangeEmailState {}

final class ChangeEmailLoading extends ChangeEmailState {}

final class ChangeEmailFailure extends ChangeEmailState {}

final class ChangeEmailSuccess extends ChangeEmailState {}
