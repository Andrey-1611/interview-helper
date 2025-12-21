import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/utils/services/notifications_service.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/utils/services/network_service.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/local_repository.dart';
import '../../../../data/repositories/remote_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final SettingsRepository _settingsRepository;
  final NetworkService _networkService;
  final Talker _talker;

  AuthBloc(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
    this._settingsRepository,
    this._networkService,
    this._talker,
  ) : super(AuthInitial()) {
    on<SignIn>(_signIn);
    on<SignInWithGoogle>(_signInWithGoogle);
    on<SignUp>(_signUp);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendEmailVerification>(_sendEmailVerification);
    on<WatchEmailVerified>(_watchEmailVerified);
    on<SignOut>(_signOut);
  }

  Future<void> _signIn(SignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      final userId = await _authRepository.signIn(event.email, event.password);
      final emailVerified = await _authRepository.checkEmailVerified();
      if (!emailVerified) {
        await _authRepository.sendEmailVerification();
        return emit(AuthEmailNotVerified());
      }
      final user = await _remoteRepository.getUserData(userId);
      final interviews = await _remoteRepository.getInterviews(userId);
      final tasks = await _remoteRepository.getTasks(userId);
      await _localRepository.setInterviews(interviews);
      await _localRepository.setTasks(tasks);
      await _localRepository.setUser(user);
      await _settingsRepository.setAuth(true);
      user.directions.isNotEmpty
          ? emit(AuthSuccess())
          : emit(AuthWithoutDirections());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      final googleUser = await _authRepository.signInWithGoogle();
      if (googleUser.name.isEmpty) {
        final user = await _remoteRepository.getUserData(googleUser.id);
        final interviews = await _remoteRepository.getInterviews(googleUser.id);
        final tasks = await _remoteRepository.getTasks(googleUser.id);
        await _localRepository.setInterviews(interviews);
        await _localRepository.setUser(user);
        await _localRepository.setTasks(tasks);
        await _settingsRepository.setAuth(true);
        user.directions.isNotEmpty
            ? emit(AuthSuccess())
            : emit(AuthWithoutDirections());
      } else {
        await _remoteRepository.setUser(googleUser);
        await _localRepository.setUser(googleUser);
        await _settingsRepository.setAuth(true);
        return emit(AuthWithoutDirections());
      }
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _signUp(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.signUp(event.name, event.email, event.password);
      await _authRepository.sendEmailVerification();
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _changeEmail(ChangeEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.changeEmail(event.email, event.password);
      await _authRepository.sendEmailVerification();
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _changePassword(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.changePassword(event.email);
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _sendEmailVerification(
    SendEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.sendEmailVerification();
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _watchEmailVerified(
    WatchEmailVerified event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.watchEmailVerified();
      final user = await _authRepository.getUser();
      await _remoteRepository.setUser(user);
      await _localRepository.setUser(user);
      await _settingsRepository.setAuth(true);
      return emit(AuthWithoutDirections());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }

  Future<void> _signOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkService.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      final user = await _localRepository.getUser();
      final interviews = await _localRepository.getInterviews();
      final tasks = await _localRepository.getTasks();
      await _remoteRepository.updateInterviews(user!.id, interviews);
      await _remoteRepository.updateTasks(user.id, tasks);
      await _authRepository.signOut();
      await _localRepository.deleteData();
      await _settingsRepository.setAuth(false);
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      _talker.handle(e, st);
    }
  }
}
