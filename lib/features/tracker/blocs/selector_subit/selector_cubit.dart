import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'selector_state.dart';

class SelectorCubit extends Cubit<SelectorState> {
  SelectorCubit() : super(SelectorState());

  void changeDirection(String direction) =>
      emit(state.copyWith(direction: direction));

  void changeType(String type) => emit(state.copyWith(type: type));

  void changeValue(String value) =>
      emit(state.copyWith(value: int.parse(value)));

  void reset() => emit(SelectorState(direction: null, type: null, value: null));
}
