part of 'check_results_bloc.dart';

@immutable
sealed class CheckResultsEvent extends Equatable {
  const CheckResultsEvent();

  @override
  List<Object?> get props => [];
}

final class CheckResults extends CheckResultsEvent {
  final List<UserInput> userInputs;

  const CheckResults({required this.userInputs});

  @override
  List<Object?> get props => [userInputs];
}

