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
  final Interview interview;

  const CheckResultsSuccess({required this.interview});

  @override
  List<Object?> get props => [interview];
}

