part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class GetProfile extends ProfileEvent {
  final String? userId;

  const GetProfile({required this.userId});
}

final class ChangeIsFavouriteInterview extends ProfileEvent {
  final String interviewId;

  const ChangeIsFavouriteInterview({required this.interviewId});

  @override
  List<Object?> get props => [interviewId];
}

final class ChangeIsFavouriteQuestion extends ProfileEvent {
  final String questionId;

  const ChangeIsFavouriteQuestion({required this.questionId});

  @override
  List<Object?> get props => [questionId];
}
