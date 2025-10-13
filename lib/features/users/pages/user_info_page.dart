import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../data/models/user/user_data.dart';
import '../blocs/get_user_bloc/get_user_bloc.dart';

class UserInfoPage extends StatelessWidget {
  final bool isCurrentUser;

  const UserInfoPage({super.key, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<GetUserBloc, GetUserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          final filterState = context.watch<FilterUserCubit>().state;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomUserInfo(
                    data: UserData.filterUser(
                      filterState.direction,
                      filterState.difficulty,
                      state.user,
                    ),
                  ),
                ),
                !isCurrentUser
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextButton(
                          onPressed: () => context.push(
                            AppRouterNames.analysis,
                            extra: state.user,
                          ),
                          child: Text(
                            'Анализ',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}
