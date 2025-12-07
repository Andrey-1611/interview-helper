part of 'interview_form_cubit.dart';

class InterviewFormState extends Equatable {
  final String? direction;
  final String? difficulty;
  final String? language;

  const InterviewFormState({this.direction, this.difficulty, this.language});

  @override
  List<Object?> get props => [direction, difficulty, language];

  InterviewFormState copyWith({
    String? direction,
    String? difficulty,
    String? language,
  }) {
    return InterviewFormState(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
      language: language ?? this.language,
    );
  }
}
