import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_analysis_state.dart';

class FilterAnalysisCubit extends Cubit<FilterAnalysisState> {
  FilterAnalysisCubit() : super(FilterAnalysisState());

  void filter(String? direction, String? difficulty, String? sort) => emit(
    state.copyWith(direction: direction, difficulty: difficulty, sort: sort),
  );

  void reset() => emit(FilterAnalysisState());
}
