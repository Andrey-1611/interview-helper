import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_data.dart';
import '../../use_cases/save_user_use_case.dart';

part 'save_user_event.dart';

part 'save_user_state.dart';

class SaveUserBloc extends Bloc<SaveUserEvent, SaveUserState> {
  final SaveUserUseCase _saveUserUseCase;

  SaveUserBloc(this._saveUserUseCase) : super(SaveUserInitial()) {
    on<SaveUser>((event, emit) async {
      emit(SaveUserLoading());
      try {
        final user = event.user;
        await _saveUserUseCase.call(user);
        emit(SaveUserSuccess(user: user));
      } catch (e) {
        emit(SaveUserFailure());
      }
    });
  }
}
