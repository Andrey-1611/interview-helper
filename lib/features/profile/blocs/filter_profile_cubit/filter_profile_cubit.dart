import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/data/enums/difficulty.dart';
import 'package:interview_master/data/enums/direction.dart';

part 'filter_profile_state.dart';

class FilterProfileCubit extends Cubit<FilterProfileState> {
  FilterProfileCubit() : super(FilterProfileState());

  void filter(Direction? direction, Difficulty? difficulty) =>
      emit(state.copyWith(direction: direction, difficulty: difficulty));

  void changeIsFavourite() =>
      emit(state.copyWith(isFavourite: !state.isFavourite));

  void reset() => emit(FilterProfileState(isFavourite: state.isFavourite));
}
