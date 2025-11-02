import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_user_state.dart';

class FilterUserCubit extends Cubit<FilterUserState> {
  FilterUserCubit() : super(FilterUserState());

  void filterUser(String? direction, String? difficulty, String? sort) => emit(
    state.copyWith(direction: direction, difficulty: difficulty, sort: sort),
  );

  void changeIsFavourite() =>
      emit(state.copyWith(isFavourite: !state.isFavourite));

  void resetUser() => emit(FilterUserState(isFavourite: state.isFavourite));
}
