import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/services/user_interface.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/auth_data_source.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/user/blocs/set_user/set_user_bloc.dart';
import '../../blocs/check_current_user_bloc/check_current_user_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CheckCurrentUserBloc(AuthDataSource())
                ..add(CheckCurrentUser()),
        ),
        BlocProvider(
          create: (context) =>
              SetUserBloc(context.read<UserInterface>()),
        ),
      ],
      child: Scaffold(
        body: BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              Navigator.pushReplacementNamed(context, AppRouterNames.home);
            } else if (state is SetUserFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Произошла ошибка, опробуйте позже')),
              );
            }
          },
          child: BlocConsumer<CheckCurrentUserBloc, CheckCurrentUserState>(
            listener: (context, state) async {
              if (state is CheckCurrentUserExists) {
                context.read<SetUserBloc>().add(
                  SetUser(userProfile: state.userProfile),
                );
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
      ),
    );
  }
}
