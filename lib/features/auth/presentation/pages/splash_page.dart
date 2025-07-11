import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source.dart';

import '../../../../app/navigation/app_router.dart';
import '../../blocs/check_current_user_bloc/check_current_user_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CheckCurrentUserBloc(FirebaseAuthDataSource())
            ..add(CheckCurrentUser()),
      child: Scaffold(
        body: BlocConsumer<CheckCurrentUserBloc, CheckCurrentUserState>(
          listener: (context, state) {
            if (state is CheckCurrentUserExists) {
              Navigator.pushReplacementNamed(context, AppRouterNames.home);
            } else if (state is CheckCurrentUserNotExists) {
              Navigator.pushReplacementNamed(context, AppRouterNames.signIn);
            }
          },
          builder: (context, state) {
            if (state is CheckCurrentUserFailure) {
              return const Center(
                child: Text(
                  'На сервере ведутся работы \nПожалуйста попробуйте позже',
                ),
              );
            }
            return Center(child: FlutterLogo(size: 128.0));
          },
        ),
      ),
    );
  }
}
