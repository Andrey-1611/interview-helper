part of 'check_results_bloc.dart';

@immutable
sealed class CheckResultsState extends Equatable {
  const CheckResultsState();

  @override
  List<Object?> get props => [];
}

final class CheckResultsInitial extends CheckResultsState {}

final class CheckResultsLoading extends CheckResultsState {}

final class CheckResultsFailure extends CheckResultsState {}

final class CheckResultsSuccess extends CheckResultsState {
  final List<GeminiResponses> geminiResponse;

  const CheckResultsSuccess({required this.geminiResponse});

  @override
  List<Object?> get props => [geminiResponse];
}

