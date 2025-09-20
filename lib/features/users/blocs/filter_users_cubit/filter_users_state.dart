part of 'filter_users_cubit.dart';

class FilterUsersState extends Equatable {
  final String direction;
  final String sort;

  const FilterUsersState({this.direction = '', this.sort = ''});

  @override
  List<Object> get props => [direction, sort];
}
