import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/l10n.dart';
import '../blocs/filter_profile_cubit/filter_profile_cubit.dart';

class CustomEmptyFilterHistory extends StatelessWidget {
  const CustomEmptyFilterHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(s.empty_history, style: theme.textTheme.displayLarge),
          TextButton(
            onPressed: () => _resetFilter(context),
            child: Text(s.reset_filter),
          ),
        ],
      ),
    );
  }

  void _resetFilter(BuildContext context) {
    final filter = context.read<FilterProfileCubit>();
    filter.reset();
    if (filter.state.isFavourite == true) filter.changeIsFavourite();
  }
}
