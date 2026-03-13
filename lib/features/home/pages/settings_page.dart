import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/cubits/settings_cubit.dart';
import 'package:interview_master/core/utils/helpers/toast_helper.dart';
import 'package:interview_master/core/utils/services/url_service.dart';
import 'package:interview_master/data/repositories/auth_repository.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:interview_master/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../../../core/utils/helpers/dialog_helper.dart';
import '../../../core/utils/services/network_service.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../../generated/l10n.dart';
import '../../users/blocs/users_bloc/users_bloc.dart';

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
            GetIt.I<NetworkService>(),
            GetIt.I<Talker>(),
          )..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            GetIt.I<AuthRepository>(),
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<SettingsRepository>(),
            GetIt.I<NetworkService>(),
            GetIt.I<Talker>(),
          ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.pop();
            context.pushReplacement(AppRouterNames.signIn);
          } else if (state is AuthNetworkFailure) {
            context.pop();
            ToastHelper.networkError();
          } else if (state is AuthFailure) {
            context.pop();
            ToastHelper.unknownError();
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
          children: [
            _UserInfo(),
            _SettingsToggleCard(
              title: s.voice,
              value: settings.state.voice,
              onChanged: (_) => settings.setVoice(!settings.state.voice),
            ),
            _SettingsToggleCard(
              title: s.russian_language,
              value: settings.state.language,
              onChanged: (_) => settings.setLanguage(!settings.state.language),
            ),
            _SettingsToggleCard(
              title: s.dark_theme,
              value: settings.state.theme,
              onChanged: (_) => settings.setTheme(!settings.state.theme),
            ),
            _SettingsToggleCard(
              title: s.notifications,
              value: settings.state.notifications,
              onChanged: (_) =>
                  settings.setNotifications(!settings.state.notifications),
            ),
            _SettingsCard(
              title: s.rate_app,
              onTap: () => GetIt.I<UrlService>().openAppInRuStore(),
              icon: Icon(Icons.favorite, color: theme.primaryColor),
            ),
            const Spacer(),
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
    final theme = Theme.of(context);
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersFailure) {
          return CustomUnknownFailure(
            onPressed: () => context.read<UsersBloc>().add(GetUser()),
          );
        } else if (state is UserSuccess) {
          return Card(
            child: ListTile(
              title: Text(
                s.user_name(state.user.name),
                style: theme.textTheme.displaySmall,
              ),
              subtitle: Text(
                s.user_email(state.user.email),
                style: theme.textTheme.bodyMedium,
              ),
              trailing: IconButton(
                onPressed: () => DialogHelper.showCustomDialog(
                  dialog: _SignOutDialog(authBloc: context.read<AuthBloc>()),
                  context: context,
                ),
                icon: Icon(Icons.logout, color: theme.colorScheme.error),
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
  final AuthBloc authBloc;

  const _SignOutDialog({required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return AlertDialog(
      content: Text(s.sign_out_confirmation, style: theme.textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: () => authBloc.add(SignOut()),
          child: Text(s.yes),
        ),
        TextButton(onPressed: () => context.pop(), child: Text(s.no)),
      ],
    );
  }
}
