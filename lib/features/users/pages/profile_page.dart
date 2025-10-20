import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_info_card.dart';
import '../../../core/utils/network_info.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/users_bloc/users_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<AuthRepository>(),
        GetIt.I<NetworkInfo>(),
      )..add(GetUser()),
      child: _ProfilePageView(),
    );
  }
}

class _ProfilePageView extends StatelessWidget {
  const _ProfilePageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final appInfo = GetIt.I<PackageInfo>();
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UserSignOutLoading) {
            DialogHelper.showLoadingDialog(context, 'Выход из аккаунта...');
          } else if (state is UserNotFound) {
            context.pop();
            context.pushReplacement(AppRouterNames.signIn);
          } else if (state is UsersNetworkFailure) {
            context.pop();
            ToastHelper.networkError();
          } else if (state is UsersFailure) {
            context.pop();
            ToastHelper.unknownError();
          }
        },
        builder: (context, state) {
          if (state is UserSuccess) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  CustomInfoCard(
                    titleText: 'Имя',
                    subtitleText: state.user.name,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomInfoCard(
                    titleText: 'Почта',
                    subtitleText: state.user.email,
                  ),
                  TextButton(
                    onPressed: () => DialogHelper.showCustomDialog(
                      dialog: _SignOutDialog(
                        userBloc: context.read<UsersBloc>(),
                      ),
                      context: context,
                    ),
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(
                        AppPalette.transparent,
                      ),
                    ),
                    child: Text(
                      'Выйти из аккаунта',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${appInfo.appName}, ${appInfo.version}+${appInfo.buildNumber}',
                  ),
                ],
              ),
            );
          }
          return const CustomLoadingIndicator();
        },
      ),
    );
  }
}

class _SignOutDialog extends StatelessWidget {
  final UsersBloc userBloc;

  const _SignOutDialog({required this.userBloc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: Text(
        'Вы уверены, что хотите выйти из аккунта?',
        style: theme.textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            userBloc.add(SignOut());
          },
          child: const Text('Да'),
        ),
        TextButton(onPressed: () => context.pop(), child: const Text('Нет')),
      ],
    );
  }
}
