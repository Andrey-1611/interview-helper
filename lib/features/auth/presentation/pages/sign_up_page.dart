import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/firebase_auth_data_source.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../interview/views/widgets/custom_button.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../data/models/user_profile.dart';
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
    return BlocProvider(
      create: (context) => SignUpBloc(FirebaseAuthDataSource()),
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
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushNamed(context, AppRouterNames.home);
        }
      },
      builder: (context, state) {
        if (state is SignUpLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SignUpFailure) {
          return const Center(
            child: Text(
              'На сервере ведутся работы \nПожалуйста попробуйте позже',
            ),
          );
        }
        return CustomButton(
          text: 'Зарегистрироваться',
          selectedColor: Colors.blue,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<SignUpBloc>().add(
                SignUp(
                  userProfile: UserProfile(
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
    );
  }
}
