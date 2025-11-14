import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_profile_state.dart';

class FilterProfileCubit extends Cubit<FilterProfileState> {
  FilterProfileCubit() : super(FilterProfileState());

  void filter(String? direction, String? difficulty, String? sort) => emit(
    state.copyWith(direction: direction, difficulty: difficulty, sort: sort),
  );

  void changeIsFavourite() =>
      emit(state.copyWith(isFavourite: !state.isFavourite));

  void reset() => emit(FilterProfileState(isFavourite: state.isFavourite));
}
