import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import '../../../app/router/app_router_names.dart';
import '../use_cases/sign_out_use_case.dart';
import '../../../app/widgets/custom_button.dart';
import '../bloc/sign_out_bloc/sign_out_bloc.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => DialogHelper.showCustomDialog(
              dialog: _SignOutDialog(),
              context: context,
            ),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: navigationShell,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Собеседование',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'История'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Рейтинг'),
        ],
      ),
    );
  }
}

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignOutBloc(GetIt.I<SignOutUseCase>()),
      child: BlocListener<SignOutBloc, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            context.pushReplacement(AppRouterNames.signIn);
          } else if (state is SignOutNetworkFailure) {
            ToastHelper.networkError();
          } else if (state is SignOutFailure) {
            ToastHelper.unknownError();
          }
        },
        child: _SignOutDialogView(),
      ),
    );
  }
}

class _SignOutDialogView extends StatelessWidget {
  const _SignOutDialogView();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Выйти из аккаунта',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        CustomButton(
          text: 'Подтвердить',
          selectedColor: AppPalette.primary,
          onPressed: () => context.read<SignOutBloc>().add(SignOut()),
        ),
      ],
    );
  }
}
