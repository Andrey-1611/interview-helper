import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';

import '../../../../../app/global/models/user_data.dart';
import '../../../../../core/errors/exceptions.dart';

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
