import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'is_connected_event.dart';
part 'is_connected_state.dart';

class IsConnectedBloc extends Bloc<IsConnectedEvent, IsConnectedState> {
  IsConnectedBloc() : super(IsConnectedInitial()) {
    on<IsConnectedEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
