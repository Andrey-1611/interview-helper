import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/domain/use_cases/start_interview_use_case.dart';
import '../../../../../core/errors/exceptions.dart';

part 'start_interview_event.dart';

part 'start_interview_state.dart';

class StartInterviewBloc
    extends Bloc<StartInterviewEvent, StartInterviewState> {
  final StartInterviewUseCase _isConnectedUseCase;

  StartInterviewBloc(this._isConnectedUseCase)
    : super(StartInterviewInitial()) {
    on<StartInterview>((event, emit) async {
      emit(StartInterviewLoading());
      try {
        final isConnect = await _isConnectedUseCase.call();
        isConnect
            ? emit(StartInterviewSuccess())
            : emit(StartInterviewNotLoading());
      } on AdsLoadingException {
        emit(StartInterviewNotLoading());
      } on NetworkException {
        emit(StartInterviewNetworkFailure());
      } catch (e) {
        emit(StartInterviewFailure());
      }
    });
  }
}
