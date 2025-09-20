import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_interviews_state.dart';

class FilterInterviewsCubit extends Cubit<FilterInterviewsState> {
  FilterInterviewsCubit() : super(FilterInterviewsState());

  void runFilter({String? direction, String? difficulty, String? sort}) {
    emit(
      FilterInterviewsState(
        direction: direction ?? '',
        difficulty: difficulty ?? '',
        sort: sort ?? '',
      ),
    );
  }

  void resetFilter() => emit(FilterInterviewsState());
}
