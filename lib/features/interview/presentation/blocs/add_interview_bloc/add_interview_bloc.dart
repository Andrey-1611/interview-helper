import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/domain/use_cases/add_interview_use_case.dart';
import '../../../data/models/interview.dart';

part 'add_interview_event.dart';

part 'add_interview_state.dart';

class AddInterviewBloc extends Bloc<AddInterviewEvent, AddInterviewState> {
  final AddInterviewUseCase _addInterviewUseCase;

  AddInterviewBloc(this._addInterviewUseCase) : super(AddInterviewInitial()) {
    on<AddInterview>((event, emit) async {
      emit(AddInterviewLoading());
      try {
        await _addInterviewUseCase.call(event.interview, event.userId);
        emit(AddInterviewSuccess());
      } catch (e) {
        emit(AddInterviewFailure(e.toString()));
      }
    });
  }
}
