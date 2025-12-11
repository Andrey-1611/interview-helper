import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/data/enums/difficulty.dart';
import 'package:interview_master/data/enums/direction.dart';

part 'filter_analysis_state.dart';

class FilterAnalysisCubit extends Cubit<FilterAnalysisState> {
  FilterAnalysisCubit() : super(FilterAnalysisState());

  void filter(Direction? direction, Difficulty? difficulty) =>
      emit(state.copyWith(direction: direction, difficulty: difficulty));

  void reset() => emit(FilterAnalysisState());
}
