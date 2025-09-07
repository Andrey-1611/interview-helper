import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/sign_out_bloc/sign_out_bloc.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_button.dart';

import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';

class CustomSignOutDialog extends StatelessWidget {
  const CustomSignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignOutBloc(GetIt.I<SignOutUseCase>()),
      child: BlocListener<SignOutBloc, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            AppRouter.pushReplacementNamed(AppRouterNames.signIn);
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
      title: Text('Выход из аккаунта'),
      actions: [
        CustomButton(
          text: 'Подтвердить',
          selectedColor: AppPalette.primary,
          onPressed: () => context.read<SignOutBloc>().add(SignOut()),
          percentsWidth: 1,
        ),
      ],
    );
  }
}
