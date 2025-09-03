import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../../data/models/my_user.dart';

part 'get_current_user_event.dart';

part 'get_current_user_state.dart';

class GetCurrentUserBloc
    extends Bloc<GetCurrentUserEvent, GetCurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  GetCurrentUserBloc(this._getCurrentUserUseCase)
    : super(GetCurrentUserInitial()) {
    on<GetCurrentUser>((event, emit) async {
      emit(GetCurrentUserLoading());
      try {
        final user = await _getCurrentUserUseCase.call();
        user != null
            ? emit(GetCurrentUserSuccess(user: user))
            : emit(GetCurrentUserNotAuth());
      } catch (e) {
        emit(GetCurrentUserFailure());
      }
    });
  }
}
