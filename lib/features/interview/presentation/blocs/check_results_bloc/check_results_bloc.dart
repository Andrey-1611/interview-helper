import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/domain/use_cases/check_resilts_use_case.dart';

part 'check_results_event.dart';

part 'check_results_state.dart';

class CheckResultsBloc extends Bloc<CheckResultsEvent, CheckResultsState> {
  final CheckResultsUseCase _checkResultsUseCase;

  CheckResultsBloc(this._checkResultsUseCase) : super(CheckResultsInitial()) {
    on<CheckResults>((event, emit) async {
      emit(CheckResultsLoading());
      try {
        final Interview interview = await _checkResultsUseCase.call(
          event.interviewInfo,
        );
        emit(CheckResultsSuccess(interview: interview));
      } catch (e) {
        emit(CheckResultsFailure(e: e.toString()));
      }
    });
  }
}
