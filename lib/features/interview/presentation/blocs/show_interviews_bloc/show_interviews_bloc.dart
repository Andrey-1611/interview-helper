import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_interviews_use_case.dart';
import '../../../data/models/interview.dart';

part 'show_interviews_event.dart';

part 'show_interviews_state.dart';

class ShowInterviewsBloc
    extends Bloc<ShowInterviewsEvent, ShowInterviewsState> {
  final ShowInterviewsUseCase _showInterviewsUseCase;

  ShowInterviewsBloc(this._showInterviewsUseCase)
    : super(ShowInterviewsInitial()) {
    on<ShowInterviews>((event, emit) async {
      emit(ShowInterviewsLoading());
      try {
        final List<Interview> interviews = await _showInterviewsUseCase.call(
          event.userId,
        );
        emit(ShowInterviewsSuccess(interviews: interviews));
      } catch (e) {
        emit(ShowInterviewsFailure(error: e.toString()));
      }
    });
  }
}
