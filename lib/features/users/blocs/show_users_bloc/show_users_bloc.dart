import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/users/use_cases/show_users_use_case.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../data/models/user/user_data.dart';

part 'show_users_event.dart';

part 'show_users_state.dart';

class ShowUsersBloc extends Bloc<ShowUsersEvent, ShowUsersState> {
  final ShowUsersUseCase _showUsersUseCase;

  ShowUsersBloc(this._showUsersUseCase) : super(ShowUsersInitial()) {
    on<ShowUsers>((event, emit) async {
      emit(ShowUsersLoading());
      try {
        final users = await _showUsersUseCase.call();
        emit(ShowUsersSuccess(users: users));
      } on NetworkException {
        emit(ShowUsersNetworkFailure());
      } catch (e) {
        emit(ShowUsersFailure(e: e.toString()));
      }
    });
  }
}
