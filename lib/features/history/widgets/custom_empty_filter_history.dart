import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../users/blocs/filter_user_cubit/filter_user_cubit.dart';

class CustomEmptyFilterHistory extends StatelessWidget {
  const CustomEmptyFilterHistory({super.key});

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
    final filter = context.read<FilterUserCubit>();
    filter.resetUser();
    if (filter.state.isFavourite == true) filter.changeIsFavourite();
  }
}
