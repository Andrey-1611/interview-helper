import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/services/user_interface.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

part 'get_user_event.dart';
part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final UserInterface localDataSourceInterface;

  GetUserBloc(this.localDataSourceInterface) : super(GetUserInitial()) {
    on<GetUser>((event, emit) async {
      emit(GetUserLoading());
      try {
        final user = await localDataSourceInterface.getUser();
        if (user != null) {
          emit(GetUserSuccess(userProfile: user));
        } else {
          emit(GetUserNotAuth());
        }
      } catch (e) {
        emit(GetUserFailure());
      }
    });
  }
}
