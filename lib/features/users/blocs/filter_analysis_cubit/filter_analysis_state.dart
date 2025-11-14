part of 'filter_analysis_cubit.dart';

class FilterAnalysisState extends Equatable {
  final String? direction;
  final String? difficulty;

  const FilterAnalysisState({this.direction, this.difficulty});

  FilterAnalysisState copyWith({
    String? direction,
    String? difficulty,
    String? sort,
    bool? isFavourite,
  }) {
    return FilterAnalysisState(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [direction, difficulty];
}
