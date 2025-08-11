import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/global_services/user/data/models/user_data.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';

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
      } catch (e) {
        emit(ShowUsersFailure());
      }
    });
  }
}
