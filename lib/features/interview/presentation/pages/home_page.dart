import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/auth/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:interview_master/features/interview/presentation/pages/user_profile_page.dart';
import 'package:interview_master/features/interview/presentation/pages/users_rating_page.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_button.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../auth/domain/use_cases/sign_out_use_case.dart';
import '../../../auth/presentation/blocs/sign_out_bloc/sign_out_bloc.dart';
import 'initial_page.dart';
import 'interviews_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _HomePageView(
      currentIndex: _currentIndex,
      changeIndex: _changeIndex,
    );
  }

  void _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _HomePageView extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> changeIndex;

  const _HomePageView({required this.currentIndex, required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => DialogHelper.showCustomDialog(
              dialog: _SignOutDialog(),
              context: context,
            ),
            icon: Icon(Icons.exit_to_app, color: AppPalette.primary),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavigationBar(
        currentIndex: currentIndex,
        changeIndex: changeIndex,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: switch (currentIndex) {
          0 => InitialPage(),
          1 => InterviewsHistoryPage(userId: null),
          2 => UserProfilePage(user: null),
          3 => UsersRatingPage(),
          _ => CustomLoadingIndicator(),
        },
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> changeIndex;

  const _BottomNavigationBar({
    required this.currentIndex,
    required this.changeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: changeIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Собеседование'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'История'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Профиль'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Рейтинг'),
      ],
    );
  }
}

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignOutBloc(GetIt.I<SignOutUseCase>()),
      child: BlocListener<SignOutBloc, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            AppRouter.pushReplacementNamed(AppRouterNames.signIn);
          } else if (state is SignOutNetworkFailure) {
            ToastHelper.networkError();
          } else if (state is SignUpFailure) {
            ToastHelper.unknownError();
          }
        },
        child: _SignOutDialogView(),
      ),
    );
  }
}

class _SignOutDialogView extends StatelessWidget {
  const _SignOutDialogView();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Выйти из аккаунта',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        CustomButton(
          text: 'Подтвердить',
          selectedColor: AppPalette.primary,
          onPressed: () => context.read<SignOutBloc>().add(SignOut()),
          percentsWidth: 6,
        ),
      ],
    );
  }
}
