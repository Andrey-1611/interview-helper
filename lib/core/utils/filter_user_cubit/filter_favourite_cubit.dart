import 'package:flutter_bloc/flutter_bloc.dart';

class FilterFavouriteCubit extends Cubit<bool> {
  FilterFavouriteCubit() : super(false);

  void changeFavourite() => emit(!state);
}
