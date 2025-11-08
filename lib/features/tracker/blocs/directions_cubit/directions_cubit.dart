import 'package:flutter_bloc/flutter_bloc.dart';

class DirectionsCubit extends Cubit<List<String>> {
  DirectionsCubit() : super([]);

  void add(String direction) {
    if (state.contains(direction)) {
      emit(state.where((dir) => dir != direction).toList());
    } else if (state.length <= 2) {
      emit([direction, ...state]);
    }
  }
}
