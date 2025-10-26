import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../../../core/theme/app_pallete.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class CustomGoogleButton extends StatelessWidget {
  const CustomGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(color: AppPalette.textSecondary)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('или'),
              ),
              Expanded(child: Divider(color: AppPalette.textSecondary)),
            ],
          ),
          SignInButton(
            Buttons.Google,
            text: 'Продолжить с Google',
            elevation: 4.0,
            onPressed: () => context.read<AuthBloc>().add(SignInWithGoogle()),
          ),
        ],
      ),
    );
  }
}
