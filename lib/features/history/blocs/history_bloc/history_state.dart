part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryFailure extends HistoryState {}

final class HistoryNetworkFailure extends HistoryState {}

final class HistorySuccess extends HistoryState {
  final List<InterviewData> interviews;

  const HistorySuccess({required this.interviews});

  @override
  List<Object> get props => [interviews];
}
