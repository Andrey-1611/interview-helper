part of 'filter_profile_cubit.dart';

class FilterProfileState extends Equatable {
  final Direction? direction;
  final Difficulty? difficulty;
  final bool isFavourite;

  const FilterProfileState({
    this.direction,
    this.difficulty,
    this.isFavourite = false,
  });

  FilterProfileState copyWith({
    Direction? direction,
    Difficulty? difficulty,
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
