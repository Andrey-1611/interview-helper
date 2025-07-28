import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

part 'set_user_event.dart';
part 'set_user_state.dart';

class SetUserBloc extends Bloc<SetUserEvent, SetUserState> {
  UserRepository localDataSourceInterface;
  SetUserBloc(this.localDataSourceInterface) : super(SetUserInitial()) {
    on<SetUser>((event, emit) async {
     emit(SetUserLoading());
     try {
       await localDataSourceInterface.setUser(event.userProfile);
       emit(SetUserSuccess());
     } catch (e) {
       emit(SetUserFailure());
     }
    });
  }
}
