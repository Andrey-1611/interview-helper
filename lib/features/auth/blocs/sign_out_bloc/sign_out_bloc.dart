import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source_interface.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final FirebaseAuthDataSourceInterface firebaseAuthDataSourceInterface;
  SignOutBloc(this.firebaseAuthDataSourceInterface) : super(SignOutInitial()) {
    on<SignOut>((event, emit) async {
      emit(SignOuLoading());
      try {
        await firebaseAuthDataSourceInterface.signOut();
        emit(SignOutSuccess());
      }  catch (e) {
        emit(SignOutFailure());
      }
    });
  }
}
