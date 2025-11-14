import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../data/models/user_data.dart';
import '../blocs/filter_profile_cubit/filter_profile_cubit.dart';

class StatisticsPage extends StatelessWidget {
  final bool isCurrentUser;

  const StatisticsPage({super.key, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          final filterState = context.watch<FilterProfileCubit>().state;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: CustomUserInfo(
              user: UserData.filterUser(
                filterState.direction,
                filterState.difficulty,
                state.user,
              ),
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}
