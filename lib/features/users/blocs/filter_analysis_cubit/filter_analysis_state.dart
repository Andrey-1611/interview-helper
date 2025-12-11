part of 'filter_analysis_cubit.dart';

class FilterAnalysisState extends Equatable {
  final Direction? direction;
  final Difficulty? difficulty;

  const FilterAnalysisState({this.direction, this.difficulty});

  FilterAnalysisState copyWith({Direction? direction, Difficulty? difficulty}) {
    return FilterAnalysisState(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [direction, difficulty];
}
