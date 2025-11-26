import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../core/utils/stopwatch_info.dart';
import '../../../../data/models/interview_info.dart';
import '../../../../data/models/user_data.dart';
import '../../../../data/repositories/ai_repository.dart';
import '../../../../data/repositories/local_repository.dart';
import '../../../../data/repositories/remote_repository.dart';

part 'interview_event.dart';

part 'interview_state.dart';

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final AIRepository _aiRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final SettingsRepository _settingsRepository;
  final NetworkInfo _networkInfo;
  final StopwatchInfo _stopwatchInfo;

  InterviewBloc(
    this._aiRepository,
    this._remoteRepository,
    this._localRepository,
    this._settingsRepository,
    this._networkInfo,
    this._stopwatchInfo,
  ) : super(InterviewInitial()) {
    on<StartInterview>(_startInterview);
    on<GetQuestions>(_getQuestions);
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
      if (interviews == 20) return emit(InterviewAttemptsFailure());
      emit(InterviewStartSuccess());
    } catch (e, st) {
      emit(InterviewFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _getQuestions(
    GetQuestions event,
    Emitter<InterviewState> emit,
  ) async {
    emit(InterviewLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(InterviewNetworkFailure());
      _stopwatchInfo.start();
      final isVoiceEnable = _settingsRepository.isVoiceEnable();
      if (event.interviewInfo.id != null) {
        final interviews = await _localRepository.getInterviews();
        final interview = interviews.firstWhere(
          (interview) => interview.id == event.interviewInfo.id,
        );
        final questions = interview.questions
            .map((question) => question.question)
            .toList();
        return emit(
          InterviewQuestionsSuccess(
            questions: questions,
            isVoiceEnable: isVoiceEnable,
          ),
        );
      } else {
        final questions = InterviewInfo.selectQuestions(event.interviewInfo);
        return emit(
          InterviewQuestionsSuccess(
            questions: questions,
            isVoiceEnable: isVoiceEnable,
          ),
        );
      }
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
      final updatedUser = UserData.updateInterviews(user, interview);
      await _remoteRepository.addInterview(interview, updatedUser);
      await _localRepository.addInterview(interview, updatedUser);
      emit(InterviewFinishSuccess(interview: interview));
    } catch (e, st) {
      emit(InterviewFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
