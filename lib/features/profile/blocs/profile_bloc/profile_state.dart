part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileFailure extends ProfileState {}

final class ProfileNetworkFailure extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final UserData user;
  final List<InterviewData> interviews;

  const ProfileSuccess({required this.user, required this.interviews});

  @override
  List<Object> get props => [user, interviews];
}
