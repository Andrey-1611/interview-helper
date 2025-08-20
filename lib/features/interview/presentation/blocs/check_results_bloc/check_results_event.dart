part of 'check_results_bloc.dart';

@immutable
sealed class CheckResultsEvent extends Equatable {
  const CheckResultsEvent();

  @override
  List<Object?> get props => [];
}

final class CheckResults extends CheckResultsEvent {
  final InterviewInfo interviewInfo;

  const CheckResults({required this.interviewInfo});

  @override
  List<Object?> get props => [interviewInfo];
}
