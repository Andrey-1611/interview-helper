import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/theme_cubit.dart';
import 'package:interview_master/core/utils/url_launch.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/network_info.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../users/blocs/users_bloc/users_bloc.dart';
import '../blocs/settings_bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            GetIt.I<SettingsRepository>(),
            GetIt.I<UrlLaunch>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetSettings()),
        ),
      ],
      child: _SettingsPageView(),
    );
  }
}

class _SettingsPageView extends StatelessWidget {
  const _SettingsPageView();

  @override
  Widget build(BuildContext context) {
    final appInfo = GetIt.I<PackageInfo>();
    final themeCubit = context.watch<ThemeCubit>();
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final onPressed = context.read<UsersBloc>().add(GetUser());
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoading) {
            DialogHelper.showLoadingDialog(context, 'Выход из аккаунта...');
          } else if (state is SignOutSuccess) {
            context.pop();
            context.pushReplacement(AppRouterNames.signIn);
          } else if (state is RuStoreSuccess) {
            context.read<SettingsBloc>().add(GetSettings());
          } else if (state is SettingsNetworkFailure) {
            context.pop();
            ToastHelper.networkError(context);
          } else if (state is SettingsFailure) {
            context.pop();
            ToastHelper.unknownError(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  if (state is UsersFailure) {
                    return CustomUnknownFailure(onPressed: () => onPressed);
                  } else if (state is UserSuccess) {
                    return Card(
                      child: SizedBox(
                        width: double.infinity,
                        height: size.height * 0.12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Пользователь',
                              style: theme.textTheme.displayMedium,
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              'Имя: ${state.user.name}',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              'Почта: ${state.user.email}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return CustomLoadingIndicator();
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      if (state is SettingsSuccess) {
                        return _SettingsToggleCard(
                          title: 'Озвучка',
                          value: state.voice,
                          onChanged: (_) => context.read<SettingsBloc>().add(
                            SetVoice(isEnable: !state.voice),
                          ),
                        );
                      }
                      return CustomLoadingIndicator();
                    },
                  ),
                  _SettingsToggleCard(
                    title: 'Темная тема',
                    value: themeCubit.state,
                    onChanged: (_) => themeCubit.changeTheme(),
                  ),
                  _SettingsCard(
                    title: 'Оценить приложение',
                    onTap: () =>
                        context.read<SettingsBloc>().add(OpenAppInRuStore()),
                    icon: Icon(Icons.favorite, color: theme.primaryColor),
                  ),
                  _SettingsCard(
                    title: 'Выйти из приложения',
                    onTap: () => DialogHelper.showCustomDialog(
                      dialog: _SignOutDialog(
                        settingsBloc: context.read<SettingsBloc>(),
                      ),
                      context: context,
                    ),
                    icon: Icon(Icons.logout, color: theme.colorScheme.error),
                  ),
                ],
              ),
              Text(
                '${appInfo.appName}, ${appInfo.version}+${appInfo.buildNumber}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Icon icon;

  const _SettingsCard({
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(title: Text(title), trailing: icon),
      ),
    );
  }
}

class _SettingsToggleCard extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleCard({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Switch(value: value, onChanged: onChanged),
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
