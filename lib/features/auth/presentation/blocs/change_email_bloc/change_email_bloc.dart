import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/network_exception.dart';
import '../../../domain/use_cases/change_email_use_case.dart';

part 'change_email_event.dart';

part 'change_email_state.dart';

class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState> {
  final ChangeEmailUseCase _changeEmailUseCase;

  ChangeEmailBloc(this._changeEmailUseCase) : super(ChangeEmailInitial()) {
    on<ChangeEmail>((event, emit) async {
      emit(ChangeEmailLoading());
      try {
        await _changeEmailUseCase(event.email, event.password);
        emit(ChangeEmailSuccess());
      } on NetworkException {
        emit(ChangeEmailNetworkFailure());
      } catch (e) {
        emit(ChangeEmailFailure());
      }
    });
  }
}
