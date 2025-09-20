part of 'filter_interviews_cubit.dart';

class FilterInterviewsState extends Equatable {
  final String direction;
  final String difficulty;
  final String sort;

  const FilterInterviewsState({
    this.direction = '',
    this.difficulty = '',
    this.sort = '',
  });

  @override
  List<Object> get props => [direction, difficulty, sort];
}
