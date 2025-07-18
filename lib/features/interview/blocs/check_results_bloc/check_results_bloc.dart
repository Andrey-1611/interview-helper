import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/remote_repository.dart';
import '../../data/models/gemini_response.dart';
import '../../data/models/user_input.dart';

part 'check_results_event.dart';

part 'check_results_state.dart';

class CheckResultsBloc extends Bloc<CheckResultsEvent, CheckResultsState> {
  final RemoteRepository remoteRepository;

  CheckResultsBloc(this.remoteRepository) : super(CheckResultsInitial()) {
    on<CheckResults>((event, emit) async {
      emit(CheckResultsLoading());
      try {
        final List<GeminiResponses> geminiResponse = await remoteRepository
            .checkAnswers(event.userInputs);
        emit(CheckResultsSuccess(geminiResponse: geminiResponse));
      } catch (e) {
        emit(CheckResultsFailure());
      }
    });
  }
}
