import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_sources/remote_data_sources/remote_data_source_interface.dart';
import '../../data/models/gemini_response.dart';
import '../../data/models/user_input.dart';
part 'check_results_event.dart';
part 'check_results_state.dart';

class CheckResultsBloc extends Bloc<CheckResultsEvent, CheckResultsState> {
  final RemoteDataSourceInterface remoteDataSourceInterface;

  CheckResultsBloc(this.remoteDataSourceInterface) : super(CheckResultsInitial()) {
    on<CheckResults>((event, emit) async {
      emit(CheckResultsLoading());
      try {
        final List<GeminiResponses> geminiResponse = await remoteDataSourceInterface.checkAnswers(
          event.userInputs,
        );
        emit(CheckResultsSuccess(geminiResponse: geminiResponse));
      } catch (e) {
        emit(CheckResultsFailure(error: e.toString()));
      }
    });
  }
}
