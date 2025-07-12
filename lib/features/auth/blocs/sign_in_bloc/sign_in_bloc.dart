import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source_interface.dart';
import 'package:interview_master/features/auth/data/models/user_profile.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FirebaseAuthDataSourceInterface firebaseAuthDataSourceInterface;

  SignInBloc(this.firebaseAuthDataSourceInterface) : super(SignInInitial()) {
    on<SignIn>((event, emit) async {
      emit(SignInLoading());
      try {
        final userProfile = await firebaseAuthDataSourceInterface.signIn(
          event.userProfile,
          event.password,
        );
        emit(SignInSuccess(userProfile: userProfile));
      } catch (e) {
        emit(SignInFailure());
      }
    });
  }
}
