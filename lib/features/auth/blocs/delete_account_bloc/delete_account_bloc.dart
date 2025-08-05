import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';

part 'delete_account_event.dart';

part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final AuthRepository authRepository;

  DeleteAccountBloc(this.authRepository) : super(DeleteAccountInitial()) {
    on<DeleteAccount>((event, emit) async {
      emit(DeleteAccountLoading());
      try {
        await authRepository.deleteAccount();
        emit(DeleteAccountSuccess());
      } catch (e) {
        emit(DeleteAccountFailure());
      }
    });
  }
}
