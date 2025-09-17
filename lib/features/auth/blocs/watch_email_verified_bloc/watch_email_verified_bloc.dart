import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../data/models/my_user.dart';
import '../../use_cases/watch_email_verified_user_case.dart';

part 'watch_email_verified_event.dart';

part 'watch_email_verified_state.dart';

class WatchEmailVerifiedBloc
    extends Bloc<WatchEmailVerifiedEvent, WatchEmailVerifiedState> {
  final WatchEmailVerifiedUseCase _watchEmailVerifiedUseCase;

  WatchEmailVerifiedBloc(this._watchEmailVerifiedUseCase)
    : super(WatchEmailVerifiedInitial()) {
    on<WatchEmailVerified>((event, emit) async {
      emit(WatchEmailVerifiedLoading());
      try {
        final user = await _watchEmailVerifiedUseCase.call();
        emit(WatchEmailVerifiedSuccess(user: user));
      } on NetworkException {
        emit(WatchEmailVerifiedNetworkFailure());
      } catch (e) {
        emit(WatchEmailVerifiedFailure());
      }
    });
  }
}
