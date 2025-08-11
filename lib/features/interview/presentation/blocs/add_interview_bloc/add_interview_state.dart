part of 'add_interview_bloc.dart';

@immutable
sealed class AddInterviewState extends Equatable {
  const AddInterviewState();

  @override
  List<Object?> get props => [];
}

final class AddInterviewInitial extends AddInterviewState {}

final class AddInterviewLoading extends AddInterviewState {}

final class AddInterviewFailure extends AddInterviewState {
  final String e;

  const AddInterviewFailure(this.e);
}

final class AddInterviewSuccess extends AddInterviewState {}
