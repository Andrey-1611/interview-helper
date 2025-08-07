part of 'add_interview_bloc.dart';

@immutable
sealed class AddInterviewEvent extends Equatable {
  const AddInterviewEvent();

  @override
  List<Object?> get props => [];
}

final class AddInterview extends AddInterviewEvent {
  final Interview interview;
  final String userId;

  const AddInterview({required this.interview, required this.userId});

  @override
  List<Object?> get props => [interview, userId];
}
