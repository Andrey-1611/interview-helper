import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../data/models/user_data.dart';
import '../blocs/filter_user_cubit/filter_user_cubit.dart';
import '../blocs/users_bloc/users_bloc.dart';

class UserInfoPage extends StatelessWidget {
  final bool isCurrentUser;

  const UserInfoPage({super.key, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          final filterState = context.watch<FilterUserCubit>().state;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: CustomUserInfo(
              data: UserData.filterUser(
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
