part of 'show_interviews_bloc.dart';

@immutable
sealed class ShowInterviewsEvent extends Equatable {
  const ShowInterviewsEvent();

  @override
  List<Object?> get props => [];
}

final class ShowInterviews extends ShowInterviewsEvent {}
