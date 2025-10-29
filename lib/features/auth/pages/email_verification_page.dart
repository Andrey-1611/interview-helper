import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/repositories/auth/auth.dart';
import '../../../data/repositories/local/local.dart';
import '../../../data/repositories/remote/remote.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class EmailVerificationPage extends StatelessWidget {
  final String password;

  const EmailVerificationPage({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        GetIt.I<AuthRepository>(),
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      )..add(WatchEmailVerified()),
      child: _EmailVerificationPageView(password: password),
    );
  }
}

class _EmailVerificationPageView extends StatelessWidget {
  final String password;

  const _EmailVerificationPageView({required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const _EmailVerificationForm(),
              TextButton(
                onPressed: () =>
                    context.read<AuthBloc>().add(SendEmailVerification()),
                child: const Text('Отпраавить письмо повторно'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.pushReplacement(
                  AppRouterNames.changeEmail,
                  extra: password,
                ),
                child: const Text('Не приходит письмо?  Изменить почту'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailVerificationForm extends StatelessWidget {
  const _EmailVerificationForm();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.pushReplacement(AppRouterNames.initial);
        } else if (state is AuthNetworkFailure) {
          ToastHelper.networkError();
        } else if (state is AuthFailure) {
          context.pushReplacement(AppRouterNames.signUp);
          ToastHelper.unknownError();
        }
      },
      child: Text(
        'Подтвердите свою почту',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
