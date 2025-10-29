import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/utils/url_launch.dart';
import 'package:interview_master/features/users/blocs/settings_bloc/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_info_card.dart';
import '../../../core/utils/network_info.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../../data/repositories/auth/auth.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';
import '../blocs/users_bloc/users_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(
            GetIt.I<AuthRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<RemoteRepository>(),
            GetIt.I<UrlLaunch>(),
            GetIt.I<NetworkInfo>(),
          ),
        ),
      ],
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
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoading) {
            DialogHelper.showLoadingDialog(context, 'Выход из аккаунта...');
          } else if (state is SignOutSuccess) {
            context.pop();
            context.pushReplacement(AppRouterNames.signIn);
          } else if (state is SettingsNetworkFailure) {
            context.pop();
            ToastHelper.networkError();
          } else if (state is SettingsFailure) {
            context.pop();
            ToastHelper.unknownError();
          }
        },
        child: BlocBuilder<UsersBloc, UsersState>(
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
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      width: size.width * 0.8,
                      child: ElevatedButton.icon(
                        onPressed: () => DialogHelper.showCustomDialog(
                          dialog: _SignOutDialog(
                            settingsBloc: context.read<SettingsBloc>(),
                          ),
                          context: context,
                        ),
                        icon: const Icon(Icons.logout),
                        iconAlignment: IconAlignment.end,
                        label: Text('Выйти из аккаунта'),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<SettingsBloc>().add(
                          OpenAppInRuStore(),
                        ),
                        icon: const Icon(Icons.favorite),
                        iconAlignment: IconAlignment.end,
                        label: Text('Оценить приложение'),
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
      ),
    );
  }
}

class _SignOutDialog extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const _SignOutDialog({required this.settingsBloc});

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
            settingsBloc.add(SignOut());
          },
          child: const Text('Да'),
        ),
        TextButton(onPressed: () => context.pop(), child: const Text('Нет')),
      ],
    );
  }
}
