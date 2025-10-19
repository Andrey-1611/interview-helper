import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/filter_favourite_cubit.dart';
import '../../../core/utils/filter_user_cubit/filter_cubit.dart';

class CustomEmptyFilterHistory extends StatelessWidget {
  final TextEditingController filterController;

  const CustomEmptyFilterHistory({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('История пуста', style: theme.textTheme.displayLarge),
          TextButton(
            onPressed: () => _resetFilter(context),
            child: Text('Сбросить фильтр'),
          ),
        ],
      ),
    );
  }

  void _resetFilter(BuildContext context) {
    final favourite = context.read<FilterFavouriteCubit>();
    context.read<FilterUserCubit>().resetUser();
    filterController.clear();
    if (favourite.state == true) favourite.changeFavourite();
  }
}
