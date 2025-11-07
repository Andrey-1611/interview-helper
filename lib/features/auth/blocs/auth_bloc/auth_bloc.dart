import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/utils/network_info.dart';
import '../../../../data/repositories/auth/auth.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  AuthBloc(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  ) : super(AuthInitial()) {
    on<SignIn>(_signIn);
    on<SignInWithGoogle>(_signInWithGoogle);
    on<SignUp>(_signUp);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendEmailVerification>(_sendEmailVerification);
    on<WatchEmailVerified>(_watchEmailVerified);
  }

  Future<void> _signIn(SignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
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
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      final googleUser = await _authRepository.signInWithGoogle();
      if (googleUser.name.isEmpty) {
        final user = await _remoteRepository.getUserData(googleUser.id);
        final interviews = await _remoteRepository.getInterviews(googleUser.id);
        final tasks = await _remoteRepository.getTasks(googleUser.id);
        await _localRepository.setInterviews(interviews);
        await _localRepository.setUser(user);
        await _localRepository.setTasks(tasks);
      } else {
        await _remoteRepository.setUser(googleUser);
        await _localRepository.setUser(googleUser);
      }
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _signUp(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.signUp(event.name, event.email, event.password);
      await _authRepository.sendEmailVerification();
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _changeEmail(ChangeEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.changeEmail(event.email, event.password);
      await _authRepository.sendEmailVerification();
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _changePassword(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.changePassword(event.email);
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _sendEmailVerification(
    SendEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.sendEmailVerification();
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _watchEmailVerified(
    WatchEmailVerified event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(AuthNetworkFailure());
      await _authRepository.watchEmailVerified();
      final user = await _authRepository.getUser();
      await _remoteRepository.setUser(user);
      await _localRepository.setUser(user);
      return emit(AuthSuccess());
    } catch (e, st) {
      emit(AuthFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
