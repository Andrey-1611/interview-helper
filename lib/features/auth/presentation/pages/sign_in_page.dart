import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/notifications/models/notification.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/auth_data_source.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user/set_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../../interview/presentation/widgets/custom_button.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInBloc(AuthDataSource())),
        BlocProvider(
          create: (context) => SetUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Почта',
                      prefixIcon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscure,
                      iconButton: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined),
                      ),
                    ),
                    _SignInButton(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouterNames.signUp);
                },
                child: const Text('Еще нет аккаунта?  Создать аккаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignInButton({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.userProfile),
              );
            }
            if (state is SignInFailure) {
              context.read<SendNotificationBloc>().add(
                SendNotification(
                  notification: MyNotification(
                    text: 'Ошибка входа',
                    icon: Icon(Icons.warning_amber),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              Navigator.pushReplacementNamed(context, AppRouterNames.home);
              context.read<GetUserBloc>().add(GetUser());
            } else if (state is SetUserFailure) {
              context.read<SendNotificationBloc>().add(
                SendNotification(
                  notification: MyNotification(
                    text: 'Ошибка входа',
                    icon: Icon(Icons.warning_amber),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<SendNotificationBloc>().add(
                SendNotification(
                  notification: MyNotification(
                    text: '${state.userProfile.name}, добро пожаловать!',
                    icon: Icon(Icons.star),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          if (state is SignInLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomButton(
            text: 'Войти',
            selectedColor: Colors.blue,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<SignInBloc>().add(
                  SignIn(
                    userProfile: UserProfile(
                      email: emailController.text.trim(),
                    ),
                    password: passwordController.text.trim(),
                  ),
                );
              }
            },
            textColor: Colors.white,
            percentsHeight: 0.06.sp,
            percentsWidth: 1.sp,
          );
        },
      ),
    );
  }
}
