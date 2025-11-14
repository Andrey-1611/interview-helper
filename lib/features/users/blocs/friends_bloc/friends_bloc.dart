import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../data/models/friend_request.dart';
import '../../../../data/models/user_data.dart';

part 'friends_event.dart';

part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  FriendsBloc(this._remoteRepository, this._localRepository, this._networkInfo)
    : super(FriendsInitial()) {
    on<SendFriendRequest>(_sendFriendRequest);
    on<GetFriendRequests>(_getFriendRequests);
    on<UpdateFriendRequest>(_updateFriendRequest);
  }

  Future<void> _sendFriendRequest(
    SendFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(FriendsNetworkFailure());
      final request = FriendRequest.create(event.fromUser, event.toUserId);
      await _remoteRepository.sendFriendRequest(request);
      return emit(FriendsSuccess());
    } catch (e, st) {
      emit(FriendsFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _getFriendRequests(
    GetFriendRequests event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(FriendsNetworkFailure());
      final user = (await _localRepository.getUser())!;
      final requests = await _remoteRepository.getFriendRequests(user.id);
      return emit(FriendRequestsSuccess(requests: requests));
    } catch (e, st) {
      emit(FriendsFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _updateFriendRequest(
    UpdateFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    emit(FriendsLoading());
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return emit(FriendsNetworkFailure());
      final request = FriendRequest.update(event.request, event.isAccepted);
      await _remoteRepository.updateFriendRequest(request);
      final requests = await _remoteRepository.getFriendRequests(event.user.id);
      return emit(FriendRequestsSuccess(requests: requests));
    } catch (e, st) {
      emit(FriendsFailure());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
