part of 'interview_form_cubit.dart';

class InterviewFormState extends Equatable {
  final String? direction;
  final String? difficulty;

  const InterviewFormState({required this.direction, required this.difficulty});

  @override
  List<Object?> get props => [direction, difficulty];
}
