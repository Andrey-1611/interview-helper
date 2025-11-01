part of 'filter_user_cubit.dart';

class FilterUserState extends Equatable {
  final String? direction;
  final String? difficulty;
  final String? sort;
  final bool isFavourite;

  const FilterUserState({
    this.direction,
    this.difficulty,
    this.sort,
    this.isFavourite = false,
  });

  FilterUserState copyWith({
    String? direction,
    String? difficulty,
    String? sort,
    bool? isFavourite,
  }) {
    return FilterUserState(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
      sort: sort ?? this.sort,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  List<Object?> get props => [direction, difficulty, sort, isFavourite];
}