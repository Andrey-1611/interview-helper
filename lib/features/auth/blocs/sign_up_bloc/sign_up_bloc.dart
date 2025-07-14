import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import '../../data/data_sources/firebase_auth_data_sources/firebase_auth_data_source_interface.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuthDataSourceInterface firebaseAuthDataSourceInterface;

  SignUpBloc(this.firebaseAuthDataSourceInterface) : super(SignUpInitial()) {
    on<SignUp>((event, emit) async {
      emit(SignUpLoading());
      try {
        final userProfile = await firebaseAuthDataSourceInterface.signUp(
          event.userProfile,
          event.password,
        );
        emit(SignUpSuccess(userProfile: userProfile));
      } catch (e) {
        emit(SignUpFailure());
      }
    });
  }
}
