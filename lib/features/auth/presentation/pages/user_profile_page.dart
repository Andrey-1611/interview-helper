import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/blocs/clear_user/clear_user_bloc.dart';
import 'package:interview_master/features/interview/views/widgets/custom_button.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_data_sources/local_data_sources_interface.dart';
import '../../../interview/blocs/get_user_bloc/get_user_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ClearUserBloc(context.read<LocalDataSourceInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<LocalDataSourceInterface>())
                ..add(GetUser()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: BlocListener<ClearUserBloc, ClearUserState>(
            listener: (context, state) {
              if (state is ClearUserSuccess) {
                Navigator.pushReplacementNamed(context, AppRouterNames.signIn);
              } else if (state is ClearUserFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Произошла ошибка, опробуйте позже')),
                );
              }
            },
            child: BlocBuilder<GetUserBloc, GetUserState>(
              builder: (context, state) {
                if (state is GetUserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetUserFailure || state is GetUserNotAuth) {
                  return const Center(
                    child: Text('Произошла ошибка, опробуйте позже'),
                  );
                } else if (state is GetUserSuccess) {
                  if (state.userProfile.name == '') {
                    context.read<GetUserBloc>().add(GetUser());
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ваше имя: ${state.userProfile.name}'),
                        Text('Ваша почта: ${state.userProfile.email}'),
                        CustomButton(
                          text: 'Выйти',
                          selectedColor: Colors.blue,
                          onPressed: () {
                            context.read<ClearUserBloc>().add(ClearUser());
                          },
                          textColor: Colors.white,
                          percentsHeight: 0.08,
                          percentsWidth: 0.35,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
