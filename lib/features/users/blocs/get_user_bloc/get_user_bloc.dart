import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/user_data.dart';
import '../../use_cases/get_user_use_case.dart';

part 'get_user_event.dart';

part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final GetUserUseCase _getUserUseCase;

  GetUserBloc(this._getUserUseCase) : super(GetUserInitial()) {
    on<GetUser>((event, emit) async {
      emit(GetUserLoading());
      try {
        final user = await _getUserUseCase.call(event.userData);
        emit(GetUserSuccess(user: user));
      } catch (e) {
        emit(GetUserFailure(e: e.toString()));
      }
    });
  }
}
