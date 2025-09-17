import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState());

  void runFilter({String? direction, String? difficulty, String? sort}) {
    emit(
      FilterState(
        direction: direction ?? '',
        difficulty: difficulty ?? '',
        sort: sort ?? '',
      ),
    );
  }

  void resetFilter() => emit(FilterState());
}
