part of 'filter_profile_cubit.dart';

class FilterProfileState extends Equatable {
  final String? direction;
  final String? difficulty;
  final bool isFavourite;

  const FilterProfileState({
    this.direction,
    this.difficulty,
    this.isFavourite = false,
  });

  FilterProfileState copyWith({
    String? direction,
    String? difficulty,
    String? sort,
    bool? isFavourite,
  }) {
    return FilterProfileState(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  List<Object?> get props => [direction, difficulty, isFavourite];
}
