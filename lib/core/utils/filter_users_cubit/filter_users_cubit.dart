import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_users_state.dart';

class FilterUsersCubit extends Cubit<FilterUsersState> {
  FilterUsersCubit() : super(FilterUsersState());

  void filterUsers(String? direction, String? sort) =>
      emit(FilterUsersState(direction: direction, sort: sort));

  void resetUsers() => emit(FilterUsersState());
}
