import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../app/global_services/user/models/my_user.dart';
import '../blocs/delete_account_bloc/delete_account_bloc.dart';
import '../blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final String password;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    password = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetUserBloc(DIContainer.getUser),
        ),
        BlocProvider(
          create: (context) =>
              DeleteAccountBloc(DIContainer.deleteAccount),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(DIContainer.signUp),
        ),
        BlocProvider(
          create: (context) => SendEmailVerificationBloc(DIContainer.sendEmailVerification),
        ),
      ],
      child: _ChangeEmailPageView(
        emailController: _emailController,
        formKey: _formKey,
        password: password,
      ),
    );
  }
}

class _ChangeEmailPageView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final String password;

  const _ChangeEmailPageView({
    required this.emailController,
    required this.formKey,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                _EmailForm(emailController: emailController),
                _ChangeEmailButton(
                  emailController: emailController,
                  formKey: formKey,
                  password: password,
                ),
                const Spacer(),
                _NavigationButton(password: password),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangeEmailButton extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final String password;

  const _ChangeEmailButton({
    required this.emailController,
    required this.formKey,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    late final MyUser user;
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserLoading) {
              DialogHelper.showLoadingDialog(context, 'Смена пароля...');
            } else if (state is GetUserSuccess) {
              user = state.user;
              context.read<DeleteAccountBloc>().add(DeleteAccount());
            } else if (state is GetUserFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<DeleteAccountBloc, DeleteAccountState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              context.read<SignUpBloc>().add(
                SignUp(
                  myUser: MyUser(
                    email: emailController.text.trim(),
                    name: user.name,
                  ),
                  password: password,
                ),
              );
            } else if (state is DeleteAccountFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.read<SendEmailVerificationBloc>().add(
                SendEmailVerification(),
              );
            } else if (state is SignUpFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(
                AppRouterNames.emailVerification,
                arguments: password,
              );
              ToastHelper.sendEmailVerification(emailController.text);
            } else if (state is SignUpFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
            }
          },
        ),
      ],
      child: _ChangeEmailButtonView(
        emailController: emailController,
        formKey: formKey,
      ),
    );
  }
}

class _ChangeEmailButtonView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const _ChangeEmailButtonView({
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Подтвердить',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<GetUserBloc>().add(GetUser());
        }
      },
    );
  }
}

class _EmailForm extends StatelessWidget {
  final TextEditingController emailController;

  const _EmailForm({required this.emailController});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: 'Почта',
      prefixIcon: Icon(Icons.email),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String password;

  const _NavigationButton({required this.password});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppRouter.pushReplacementNamed(
          AppRouterNames.emailVerification,
          arguments: password,
        );
      },
      child: const Text('Вернуться на экран подтверджения почты'),
    );
  }
}
