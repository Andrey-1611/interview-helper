import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/data/models/user/user_data.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  UsersBloc(this._remoteRepository, this._localRepository, this._networkInfo)
    : super(UsersInitial()) {
    on<GetUser>(_getUser);
    on<GetUsers>(_getUsers);
    on<GetCurrentUser>(_getCurrentUser);
  }

  Future<void> _getUser(GetUser event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      if (event.user != null) return emit(UserSuccess(user: event.user!));
      final user = await _localRepository.getUser();
      return emit(UserSuccess(user: user!));
    } catch (e, st) {
      emit(UsersFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _getUsers(GetUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(UsersNetworkFailure());
      final users = await _remoteRepository.getUsers();
      final currentUser = await _localRepository.getUser();
      emit(UsersSuccess(users: users, currentUser: currentUser!));
    } catch (e, st) {
      emit(UsersFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _getCurrentUser(
    GetCurrentUser event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      final user = await _localRepository.getUser();
      if (user == null) return emit(UserNotFound());
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(UserSuccess(user: user));
      final interviews = await _localRepository.getInterviews();
      await _remoteRepository.updateInterviews(user.id, interviews);
      return emit(UserSuccess(user: user));
    } catch (e, st) {
      emit(UsersFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
