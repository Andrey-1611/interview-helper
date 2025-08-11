import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/global_services/user/data/models/user_data.dart';
import 'package:interview_master/app/global_services/user/domain/use_cases/save_user_use_case.dart';

part 'save_user_event.dart';

part 'save_user_state.dart';

class SaveUserBloc extends Bloc<SaveUserEvent, SaveUserState> {
  final SaveUserUseCase _saveUserUseCase;

  SaveUserBloc(this._saveUserUseCase) : super(SaveUserInitial()) {
    on<SaveUser>((event, emit) async {
      emit(SaveUserLoading());
      try {
        await _saveUserUseCase.call(event.user);
        emit(SaveUserSuccess());
      } catch (e) {
        emit(SaveUserFailure());
      }
    });
  }
}
