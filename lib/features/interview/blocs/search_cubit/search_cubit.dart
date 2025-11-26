import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void update(String text) => emit(text);
}
