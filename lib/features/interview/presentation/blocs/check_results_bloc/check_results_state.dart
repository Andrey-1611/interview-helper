part of 'check_results_bloc.dart';

@immutable
sealed class CheckResultsState extends Equatable {
  const CheckResultsState();

  @override
  List<Object?> get props => [];
}

final class CheckResultsInitial extends CheckResultsState {}

final class CheckResultsLoading extends CheckResultsState {}

final class CheckResultsFailure extends CheckResultsState {
  final String e;

  const CheckResultsFailure({required this.e});
}

final class CheckResultsSuccess extends CheckResultsState {
  final List<Question> questions;

  const CheckResultsSuccess({required this.questions});

  @override
  List<Object?> get props => [questions];
}

