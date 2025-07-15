import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final AuthRepository authRepository;
  SignOutBloc(this.authRepository) : super(SignOutInitial()) {
    on<SignOut>((event, emit) async {
      emit(SignOuLoading());
      try {
        await authRepository.signOut();
        emit(SignOutSuccess());
      }  catch (e) {
        emit(SignOutFailure());
      }
    });
  }
}
