import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/data/enums/direction.dart';

class DirectionsCubit extends Cubit<List<Direction>> {
  DirectionsCubit() : super([]);

  void add(Direction direction) {
    if (state.contains(direction)) {
      emit(state.where((dir) => dir != direction).toList());
    } else if (state.length <= 2) {
      emit([direction, ...state]);
    }
  }
}
