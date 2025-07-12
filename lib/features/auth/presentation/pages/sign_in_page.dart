import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/models/user_profile.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_data_sources/local_data_sources_interface.dart';
import '../../../interview/views/widgets/custom_button.dart';
import '../../blocs/set_user/set_user_bloc.dart';
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
        BlocProvider(create: (context) => SignInBloc(FirebaseAuthDataSource())),
        BlocProvider(
          create: (context) =>
              SetUserBloc(context.read<LocalDataSourceInterface>()),
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
    return BlocListener<SetUserBloc, SetUserState>(
      listener: (context, state) {
        if (state is SetUserSuccess) {
          Navigator.pushReplacementNamed(context, AppRouterNames.home);
        } else if (state is SetUserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Произошла ошибка, опробуйте позже')),
          );
        }
      },
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            context.read<SetUserBloc>().add(
              SetUser(userProfile: state.userProfile),
            );
          }
        },
        builder: (context, state) {
          if (state is SignInLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SignInFailure) {
            return Center(
              child: Text(
                'На сервере ведутся работы \nПожалуйста попробуйте позже',
              ),
            );
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
