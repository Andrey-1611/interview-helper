import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';

import '../../../data/models/my_user.dart';

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
        await _changePasswordUseCase.call(event.user);
        emit(ChangePasswordSuccess());
      } catch (e) {
        emit(ChangePasswordFailure());
      }
    });
  }
}
