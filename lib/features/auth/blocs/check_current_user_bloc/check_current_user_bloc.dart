import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source_interface.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

part 'check_current_user_event.dart';
part 'check_current_user_state.dart';

class CheckCurrentUserBloc extends Bloc<CheckCurrentUserEvent, CheckCurrentUserState> {
  final FirebaseAuthDataSourceInterface firebaseAuthDataSourceInterface;
  CheckCurrentUserBloc(this.firebaseAuthDataSourceInterface) : super(CheckCurrentUserInitial()) {
    on<CheckCurrentUser>((event, emit) async {
      try {
        final user = await firebaseAuthDataSourceInterface.checkCurrentUser();
        if (user != null) {
          emit(CheckCurrentUserExists(userProfile: user));
        } else {
          emit(CheckCurrentUserNotExists());
        }
      } catch (e) {
        emit(CheckCurrentUserFailure());
      }
    });
  }
}
