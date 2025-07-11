import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/models/user_profile.dart';

part 'set_user_event.dart';
part 'set_user_state.dart';

class SetUserBloc extends Bloc<SetUserEvent, SetUserState> {
  SetUserBloc() : super(SetUserInitial()) {
    on<SetUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
