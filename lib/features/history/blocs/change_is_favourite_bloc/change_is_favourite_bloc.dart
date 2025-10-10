import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/history/use_cases/change_is_favourite_use_case.dart';
import '../../../../core/errors/exceptions.dart';

part 'change_is_favourite_event.dart';

part 'change_is_favourite_state.dart';

class ChangeIsFavouriteBloc
    extends Bloc<ChangeIsFavouriteEvent, ChangeIsFavouriteState> {
  final ChangeIsFavouriteUseCase _changeIsFavouriteUseCase;

  ChangeIsFavouriteBloc(this._changeIsFavouriteUseCase)
    : super(ChangeIsFavouriteInitial()) {
    on<ChangeIsFavourite>((event, emit) async {
      emit(ChangeIsFavouriteLoading());
      try {
        await _changeIsFavouriteUseCase.call(event.id);
        emit(ChangeIsFavouriteSuccess());
      } on NetworkException {
        emit(ChangeIsFavouriteNetworkFailure());
      } catch (e) {
        emit(ChangeIsFavouriteFailure());
      }
    });
  }
}
