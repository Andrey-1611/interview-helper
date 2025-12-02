import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/settings_cubit/settings_cubit.dart';
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
import '../../../generated/l10n.dart';
import '../../users/blocs/users_bloc/users_bloc.dart';
import '../blocs/settings_bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
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
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoading) {
            DialogHelper.showLoadingDialog(context, s.signing_out);
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
        child: _SettingsPageView(),
      ),
    );
  }
}

class _SettingsPageView extends StatelessWidget {
  const _SettingsPageView();

  @override
  Widget build(BuildContext context) {
    final appInfo = GetIt.I<PackageInfo>();
    final theme = Theme.of(context);
    final s = S.of(context);
    final settings = context.watch<SettingsCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _UserInfo(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SettingsToggleCard(
                  title: s.voice,
                  value: settings.state.voice,
                  onChanged: (_) => settings.setVoice(!settings.state.voice),
                ),
                _SettingsToggleCard(
                  title: s.russian_language,
                  value: settings.state.language,
                  onChanged: (_) =>
                      settings.setLanguage(!settings.state.language),
                ),
                _SettingsToggleCard(
                  title: s.dark_theme,
                  value: settings.state.theme,
                  onChanged: (_) => settings.setTheme(!settings.state.theme),
                ),
                _SettingsCard(
                  title: s.rate_app,
                  onTap: () =>
                      context.read<SettingsBloc>().add(OpenAppInRuStore()),
                  icon: Icon(Icons.favorite, color: theme.primaryColor),
                ),
                _SettingsCard(
                  title: s.sign_out,
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
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersFailure) {
          return CustomUnknownFailure(
            onPressed: () => context.read<UsersBloc>().add(GetUser()),
          );
        } else if (state is UserSuccess) {
          return Card(
            child: SizedBox(
              width: double.infinity,
              height: size.height * 0.12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(s.user, style: theme.textTheme.displayMedium),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    s.user_name(state.user.name),
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    s.user_email(state.user.email),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
        return CustomLoadingIndicator();
      },
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
    final s = S.of(context);
    return AlertDialog(
      content: Text(s.sign_out_confirmation, style: theme.textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            settingsBloc.add(SignOut());
          },
          child: Text(s.yes),
        ),
        TextButton(onPressed: () => context.pop(), child: Text(s.no)),
      ],
    );
  }
}
