part of 'history_bloc.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

final class GetInterviews extends HistoryEvent {
  final String? userId;

  const GetInterviews({required this.userId});
}

final class ChangeIsFavouriteInterview extends HistoryEvent {
  final String interviewId;

  const ChangeIsFavouriteInterview({required this.interviewId});

  @override
  List<Object?> get props => [interviewId];
}

final class ChangeIsFavouriteQuestion extends HistoryEvent {
  final String questionId;

  const ChangeIsFavouriteQuestion({required this.questionId});

  @override
  List<Object?> get props => [questionId];
}
