import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_tasks_state.dart';

class FilterTasksCubit extends Cubit<FilterTasksState> {
  FilterTasksCubit() : super(FilterTasksState());

  void changeIsCompleted() {
    emit(
      FilterTasksState(
        direction: state.direction,
        type: state.type,
        sort: state.sort,
        isCompleted: switch (state.isCompleted) {
          null => true,
          true => false,
          false => null,
        },
      ),
    );
  }

  void runFilter(String? direction, String? type, String? sort) =>
      emit(state.copyWith(direction: direction, type: type, sort: sort));

  void reset() => emit(
    FilterTasksState(
      direction: null,
      type: null,
      sort: null,
      isCompleted: state.isCompleted,
    ),
  );
}
