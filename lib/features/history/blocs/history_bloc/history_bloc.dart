import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  HistoryBloc(this._remoteRepository, this._localRepository, this._networkInfo)
    : super(HistoryInitial()) {
    on<GetInterviews>(_getInterviews);
    on<ChangeIsFavouriteInterview>(_changeIsFavouriteInterview);
    on<ChangeIsFavouriteQuestion>(_changeIsFavouriteQuestion);
  }

  Future<void> _getInterviews(
    GetInterviews event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(HistoryLoading());
      if (event.userId != null) {
        final isConnected = await _networkInfo.isConnected;
        if (!isConnected) return emit(HistoryNetworkFailure());
        final interviews = await _remoteRepository.getInterviews(event.userId!);
        return emit(HistorySuccess(interviews: interviews));
      }
      final interviews = await _localRepository.getInterviews();
      return emit(HistorySuccess(interviews: interviews));
    } catch (e, st) {
      emit(HistoryFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _changeIsFavouriteInterview(
    ChangeIsFavouriteInterview event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _localRepository.changeIsFavouriteInterview(event.interviewId);
      final interviews = await _localRepository.getInterviews();
      return emit(HistorySuccess(interviews: interviews));
    } catch (e, st) {
      emit(HistoryFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _changeIsFavouriteQuestion(
    ChangeIsFavouriteQuestion event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _localRepository.changeIsFavouriteQuestion(event.questionId);
      final interviews = await _localRepository.getInterviews();
      return emit(HistorySuccess(interviews: interviews));
    } catch (e, st) {
      emit(HistoryFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
