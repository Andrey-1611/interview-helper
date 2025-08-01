import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';

part 'clear_user_event.dart';
part 'clear_user_state.dart';

class ClearUserBloc extends Bloc<ClearUserEvent, ClearUserState> {
  final UserRepository localDataSourceInterface;
  ClearUserBloc(this.localDataSourceInterface) : super(ClearUserInitial()) {
    on<ClearUser>((event, emit) async {
      emit(ClearUserLoading());
      try {
        await localDataSourceInterface.clearUser();
        emit(ClearUserSuccess());
      } catch (e) {
        emit(ClearUserFailure());
      }
    });
  }
}
