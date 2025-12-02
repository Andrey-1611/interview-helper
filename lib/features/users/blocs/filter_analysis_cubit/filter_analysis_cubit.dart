import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_analysis_state.dart';

class FilterAnalysisCubit extends Cubit<FilterAnalysisState> {
  FilterAnalysisCubit() : super(FilterAnalysisState());

  void filter(String? direction, String? difficulty, String? sort) =>
      emit(state.copyWith(direction: direction, difficulty: difficulty));

  void reset() => emit(FilterAnalysisState());
}
