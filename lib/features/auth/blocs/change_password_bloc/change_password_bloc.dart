import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../use_cases/change_password_use_case.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordBloc(this._changePasswordUseCase)
    : super(ChangePasswordInitial()) {
    on<ChangePassword>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await _changePasswordUseCase.call(event.email);
        emit(ChangePasswordSuccess());
      } on NetworkException {
        emit(ChangePasswordNetworkFailure());
      } catch (e) {
        emit(ChangePasswordFailure());
      }
    });
  }
}
