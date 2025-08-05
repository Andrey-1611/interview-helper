import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/watch_email_verified_user_case.dart';

import '../../../data/models/email_verification_result.dart';

part 'watch_email_verified_event.dart';
part 'watch_email_verified_state.dart';

class WatchEmailVerifiedBloc extends Bloc<WatchEmailVerifiedEvent, WatchEmailVerifiedState> {
  final WatchEmailVerifiedUseCase _watchEmailVerifiedUseCase;
  WatchEmailVerifiedBloc(this._watchEmailVerifiedUseCase) : super(WatchEmailVerifiedInitial()) {
    on<WatchEmailVerified>((event, emit) async {
      emit(WatchEmailVerifiedLoading());
      try {
        final EmailVerificationResult? result = await _watchEmailVerifiedUseCase.call();
        emit(WatchEmailVerifiedSuccess(result: result!));
      } catch (e) {
        emit(WatchEmailVerifiedFailure());
      }
    });
  }
}
