import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/core/utils/url_launch.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../data/repositories/auth/auth.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthRepository _authRepository;
  final LocalRepository _localRepository;
  final RemoteRepository _remoteRepository;
  final UrlLaunch _urlLaunch;
  final NetworkInfo _networkInfo;

  SettingsBloc(
    this._authRepository,
    this._localRepository,
    this._remoteRepository,
    this._urlLaunch,
    this._networkInfo,
  ) : super(SettingsInitial()) {
    on<SignOut>(_signOut);
    on<OpenAppInRuStore>(_openAppInRuStore);
  }

  Future<void> _signOut(SignOut event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(SettingsNetworkFailure());
      final user = await _localRepository.getUser();
      final interviews = await _localRepository.getInterviews();
      final tasks = await _localRepository.getTasks();
      await _remoteRepository.updateInterviews(user!.id, interviews);
      await _remoteRepository.updateTasks(user.id, tasks);
      await _authRepository.signOut();
      await _localRepository.deleteData();
      return emit(SignOutSuccess());
    } catch (e, st) {
      emit(SettingsFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _openAppInRuStore(
    OpenAppInRuStore event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(SettingsNetworkFailure());
      await _urlLaunch.openAppInRuStore();
      return emit(SettingsSuccess());
    } catch (e, st) {
      emit(SettingsFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
