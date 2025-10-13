import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/history/use_cases/change_is_favourite_interview_use_case.dart';
import 'package:interview_master/features/history/use_cases/change_is_favourite_question_use_case.dart';
import '../../../../core/errors/exceptions.dart';

part 'change_is_favourite_event.dart';

part 'change_is_favourite_state.dart';

class ChangeIsFavouriteBloc
    extends Bloc<ChangeIsFavouriteEvent, ChangeIsFavouriteState> {
  final ChangeIsFavouriteInterviewUseCase _changeIsFavouriteInterviewUseCase;
  final ChangeIsFavouriteQuestionUseCase _changeIsFavouriteQuestionUseCase;

  ChangeIsFavouriteBloc(
    this._changeIsFavouriteInterviewUseCase,
    this._changeIsFavouriteQuestionUseCase,
  ) : super(ChangeIsFavouriteInitial()) {
    on<ChangeIsFavouriteInterview>(_changeIsFavouriteInterview);
    on<ChangeIsFavouriteQuestion>(_changeIsFavouriteQuestion);
  }

  Future<void> _changeIsFavouriteInterview(
    ChangeIsFavouriteInterview event,
    Emitter<ChangeIsFavouriteState> emit,
  ) async {
    emit(ChangeIsFavouriteLoading());
    try {
      await _changeIsFavouriteInterviewUseCase.call(event.id);
      emit(ChangeIsFavouriteSuccess());
    } on NetworkException {
      emit(ChangeIsFavouriteNetworkFailure());
    } catch (e) {
      emit(ChangeIsFavouriteFailure());
    }
  }

  Future<void> _changeIsFavouriteQuestion(
    ChangeIsFavouriteQuestion event,
    Emitter<ChangeIsFavouriteState> emit,
  ) async {
    emit(ChangeIsFavouriteLoading());
    try {
      await _changeIsFavouriteQuestionUseCase.call(event.id);
      emit(ChangeIsFavouriteSuccess());
    } on NetworkException {
      emit(ChangeIsFavouriteNetworkFailure());
    } catch (e) {
      emit(ChangeIsFavouriteFailure());
    }
  }
}
