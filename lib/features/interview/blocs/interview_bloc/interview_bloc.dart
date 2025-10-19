import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/data/models/interview/interview_data.dart';
import 'package:interview_master/data/models/interview/interview_info.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../core/utils/stopwatch_info.dart';
import '../../../../data/models/user/user_data.dart';
import '../../../../data/repositories/ai_repository.dart';
import '../../../../data/repositories/local_repository.dart';
import '../../../../data/repositories/remote_repository.dart';

part 'interview_event.dart';

part 'interview_state.dart';

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final AIRepository _aiRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;
  final StopwatchInfo _stopwatchInfo;

  InterviewBloc(
    this._aiRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
    this._stopwatchInfo,
  ) : super(InterviewInitial()) {
    on<StartInterview>(_startInterview);
    on<FinishInterview>(_finishInterview);
  }

  Future<void> _startInterview(
    StartInterview event,
    Emitter<InterviewState> emit,
  ) async {
    emit(InterviewLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(InterviewNetworkFailure());
      final interviews = await _localRepository.getTotalInterviewsToady();
      if (interviews == 10) return emit(InterviewAttemptsFailure());
      _stopwatchInfo.start();
      emit(InterviewStartSuccess());
    } catch (e, st) {
      emit(InterviewFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _finishInterview(
    FinishInterview event,
    Emitter<InterviewState> emit,
  ) async {
    emit(InterviewLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(InterviewNetworkFailure());

      final duration = _stopwatchInfo.stop();
      final questions = await _aiRepository.checkAnswers(event.interviewInfo);
      final interview = InterviewData.fromQuestions(
        questions,
        event.interviewInfo,
        duration,
      );

      final user = (await _localRepository.getUser())!;
      final updatedUser = UserData.updateData(user, interview);
      await _remoteRepository.addInterview(interview, updatedUser);
      await _localRepository.addInterview(interview, updatedUser);
      emit(InterviewFinishSuccess(interview: interview));
    } catch (e, st) {
      emit(InterviewFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
