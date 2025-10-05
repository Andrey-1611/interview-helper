import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../data/models/user/user_data.dart';
import '../blocs/get_user_bloc/get_user_bloc.dart';

class UserInfoPage extends StatelessWidget {
  final UserData? user;

  const UserInfoPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserBloc, GetUserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          final filterState = context.watch<FilterUserCubit>().state;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomUserInfo(
              data: UserData.getStatsInfo(
                UserData.filterUser(
                  filterState.direction,
                  filterState.difficulty,
                  state.user,
                ),
              ),
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}
