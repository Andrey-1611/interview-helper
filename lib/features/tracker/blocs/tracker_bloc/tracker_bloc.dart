import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/data/models/task.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../data/models/user_data.dart';
import '../../../../data/repositories/local_repository.dart';
import '../../../../data/repositories/remote_repository.dart';

part 'tracker_event.dart';

part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final LocalRepository _localRepository;
  final RemoteRepository _remoteRepository;
  final NetworkInfo _networkInfo;

  TrackerBloc(this._localRepository, this._remoteRepository, this._networkInfo)
    : super(TrackerInitial()) {
    on<GetTasks>(_getTasks);
    on<CreateTask>(_createTask);
    on<DeleteTask>(_deleteTask);
    on<SetDirections>(_setDirections);
  }

  Future<void> _getTasks(GetTasks event, Emitter<TrackerState> emit) async {
    emit(TrackerLoading());
    try {
      final tasks = await _localRepository.getTasks();
      return emit(TrackerSuccess(tasks: tasks));
    } catch (e, st) {
      emit(TrackerFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _createTask(CreateTask event, Emitter<TrackerState> emit) async {
    emit(TrackerLoading());
    try {
      final task = Task.create(event.targetValue, event.type, event.direction);
      await _localRepository.createTask(task);
      final tasks = await _localRepository.getTasks();
      return emit(TrackerSuccess(tasks: tasks));
    } catch (e, st) {
      emit(TrackerFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _deleteTask(DeleteTask event, Emitter<TrackerState> emit) async {
    try {
      await _localRepository.deleteTask(event.id);
      final tasks = await _localRepository.getTasks();
      return emit(TrackerSuccess(tasks: tasks));
    } catch (e, st) {
      emit(TrackerFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _setDirections(
    SetDirections event,
    Emitter<TrackerState> emit,
  ) async {
    emit(TrackerLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(TrackerNetworkFailure());
      final user = await _localRepository.getUser();
      final updatedUser = UserData.updateDirections(user!, event.directions);
      await _localRepository.setUser(updatedUser);
      await _remoteRepository.setUser(updatedUser);
      return emit(TrackerDirectionsSuccess());
    } catch (e, st) {
      emit(TrackerFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
