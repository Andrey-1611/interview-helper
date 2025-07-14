import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source_interface.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import '../../../../core/exceptions/auth_exception.dart';

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
      } on AuthException  catch (e) {
        emit(SignInFailure(error: e.toString()));
      } catch (e) {
        emit(SignInFailure(error: e.toString()));
      }
    });
  }
}
