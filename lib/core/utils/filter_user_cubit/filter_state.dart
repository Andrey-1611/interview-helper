part of 'filter_cubit.dart';

class FilterUserState extends Equatable {
  final String? direction;
  final String? difficulty;
  final String? sort;

  const FilterUserState({this.direction, this.difficulty, this.sort});

  @override
  List<Object?> get props => [direction, difficulty, sort];
}

/*
part of 'filter_cubit.dart';

sealed class FilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class FilterInitial extends FilterState {}

final class FilterUser extends FilterState {
  final String? direction;
  final String? difficulty;
  final String? sort;

  FilterUser({this.direction, this.difficulty, this.sort});

  @override
  List<Object?> get props => [direction, difficulty];

  UserData filterUser(UserData user) =>
      FilterData.filterUser(direction, difficulty, user);

  List<InterviewData> filterInterviews(List<InterviewData> interviews) =>
      FilterData.filterInterviews(direction, difficulty, sort, interviews);
}

final class FilterUsers extends FilterState {
  final String? direction;
  final String? sort;

  FilterUsers({this.direction, this.sort});

  @override
  List<Object?> get props => [direction, sort];

  List<UserData> filterUsers(List<UserData> users) =>
      FilterData.filterUsers(direction, sort, users);
}
*/
