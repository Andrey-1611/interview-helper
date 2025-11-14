import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../data/repositories/local_repository.dart';
import '../../../../data/repositories/remote_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  ProfileBloc(this._remoteRepository, this._localRepository, this._networkInfo)
    : super(ProfileInitial()) {
    on<GetProfile>(_getProfile);
    on<ChangeIsFavouriteInterview>(_changeIsFavouriteInterview);
    on<ChangeIsFavouriteQuestion>(_changeIsFavouriteQuestion);
  }

  Future<void> _getProfile(GetProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      if (event.userId != null) {
        final isConnected = await _networkInfo.isConnected;
        if (!isConnected) return emit(ProfileNetworkFailure());
        final user = await _remoteRepository.getUserData(event.userId!);
        final interviews = await _remoteRepository.getInterviews(event.userId!);
        return emit(ProfileSuccess(user: user, interviews: interviews));
      }
      final user = (await _localRepository.getUser())!;
      final interviews = await _localRepository.getInterviews();
      return emit(ProfileSuccess(user: user, interviews: interviews));
    } catch (e, st) {
      emit(ProfileFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _changeIsFavouriteInterview(
    ChangeIsFavouriteInterview event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _localRepository.changeIsFavouriteInterview(event.interviewId);
      final user = (await _localRepository.getUser())!;
      final interviews = await _localRepository.getInterviews();
      return emit(ProfileSuccess(user: user, interviews: interviews));
    } catch (e, st) {
      emit(ProfileFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _changeIsFavouriteQuestion(
    ChangeIsFavouriteQuestion event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _localRepository.changeIsFavouriteQuestion(event.questionId);
      final user = (await _localRepository.getUser())!;
      final interviews = await _localRepository.getInterviews();
      return emit(ProfileSuccess(user: user, interviews: interviews));
    } catch (e, st) {
      emit(ProfileFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
