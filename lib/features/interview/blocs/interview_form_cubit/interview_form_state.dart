part of 'interview_form_cubit.dart';

class InterviewFormState extends Equatable {
  final Direction? direction;
  final Difficulty? difficulty;
  final Language? language;

  const InterviewFormState({this.direction, this.difficulty, this.language});

  @override
  List<Object?> get props => [direction, difficulty, language];

  InterviewFormState copyWith({
    Direction? direction,
    Difficulty? difficulty,
    Language? language,
  }) {
    return InterviewFormState(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
      language: language ?? this.language,
    );
  }
}
