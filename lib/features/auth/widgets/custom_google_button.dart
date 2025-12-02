import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import '../../../generated/l10n.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class CustomGoogleButton extends StatelessWidget {
  const CustomGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final s = S.of(context);
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(s.or),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SignInButton(
            Buttons.Google,
            text: s.continue_with_google,
            elevation: 4.0,
            onPressed: () => context.read<AuthBloc>().add(SignInWithGoogle()),
          ),
        ],
      ),
    );
  }
}
