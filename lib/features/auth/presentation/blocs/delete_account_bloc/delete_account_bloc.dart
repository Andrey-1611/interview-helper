import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/delete_account_use_case.dart';

part 'delete_account_event.dart';

part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountBloc(this._deleteAccountUseCase)
    : super(DeleteAccountInitial()) {
    on<DeleteAccount>((event, emit) async {
      emit(DeleteAccountLoading());
      try {
        await _deleteAccountUseCase.call();
        emit(DeleteAccountSuccess());
      } catch (e) {
        emit(DeleteAccountFailure());
      }
    });
  }
}
