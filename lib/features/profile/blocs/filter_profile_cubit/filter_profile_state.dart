part of 'filter_profile_cubit.dart';

class FilterProfileState extends Equatable {
  final String? direction;
  final String? difficulty;
  final String? sort;
  final bool isFavourite;

  const FilterProfileState({
    this.direction,
    this.difficulty,
    this.sort,
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
      sort: sort ?? this.sort,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  List<Object?> get props => [direction, difficulty, sort, isFavourite];
}
