part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final String direction;
  final String difficulty;
  final String sort;

  const FilterState({
    this.direction = '',
    this.difficulty = '',
    this.sort = '',
  });

  @override
  List<Object> get props => [direction, difficulty, sort];
}
