import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

part 'get_user_event.dart';

part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final UserRepository userRepository;

  GetUserBloc(this.userRepository) : super(GetUserInitial()) {
    on<GetUser>((event, emit) async {
      emit(GetUserLoading());
      try {
        final user = await userRepository.getUser();
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
