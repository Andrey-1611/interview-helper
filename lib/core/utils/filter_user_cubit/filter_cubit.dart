import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterUserCubit extends Cubit<FilterUserState> {
  FilterUserCubit() : super(FilterUserState());

  void filterUser(String? direction, String? difficulty, String? sort) => emit(
    FilterUserState(direction: direction, difficulty: difficulty, sort: sort),
  );

  void resetUser() => emit(FilterUserState());
}
