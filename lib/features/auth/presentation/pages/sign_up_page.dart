import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/auth_data_source.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/notifications/services/notification_service.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user/set_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../../interview/presentation/widgets/custom_button.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../../../core/global_services/user/models/user_profile.dart';
import '../widgets/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpBloc(AuthDataSource())),
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
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: 'Имя',
                      prefixIcon: const Icon(Icons.person),
                      keyboardType: TextInputType.name,
                    ),
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
                    _SignUpButton(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouterNames.signIn);
                },
                child: const Text('Уже есть аккаунт?  Войти в аккаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignUpButton({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.userProfile),
              );
            } else if (state is SignUpFailure) {
              context.read<SendNotificationBloc>().add(
                SendNotification(
                  notification: MyNotification(
                    text: 'Ошибка регистрации',
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
                    text: 'Ошибка регистрации',
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
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          if (state is SignUpLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomButton(
            text: 'Зарегистрироваться',
            selectedColor: Colors.blue,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<SignUpBloc>().add(
                  SignUp(
                    userProfile: UserProfile(
                      id: Uuid().v1(),
                      email: emailController.text.trim(),
                      name: nameController.text.trim(),
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
