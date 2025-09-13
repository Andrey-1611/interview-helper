import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/domain/use_cases/start_interview_use_case.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/router/app_router_names.dart';
import '../blocs/start_interview_bloc/start_interview_bloc.dart';
import '../widgets/custom_button.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String direction = '';
  String difficultly = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartInterviewBloc(GetIt.I<StartInterviewUseCase>()),
      child: _InitialPageView(
        difficultly: difficultly,
        direction: direction,
        changeDirection: _changeDirection,
        changeDifficultly: _changeDifficultly,
      ),
    );
  }

  void _changeDirection(String value) {
    setState(() {
      direction = value;
    });
  }

  void _changeDifficultly(String value) {
    setState(() {
      difficultly = value;
    });
  }
}

class _InitialPageView extends StatelessWidget {
  final String difficultly;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficultly;

  const _InitialPageView({
    required this.difficultly,
    required this.changeDirection,
    required this.changeDifficultly,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _DirectionDropdownButton(
            changeDirection: changeDirection,
            direction: direction,
          ),
          SizedBox(height: size.height * 0.03),
          _DifficultlyDropdownButton(
            difficultly: difficultly,
            changeDifficultly: changeDifficultly,
          ),
          SizedBox(height: size.height * 0.03),
          _InterviewButton(difficulty: difficultly, direction: direction),
        ],
      ),
    );
  }
}

class _DirectionDropdownButton extends StatelessWidget {
  final ValueChanged<String> changeDirection;
  final String direction;

  const _DirectionDropdownButton({
    required this.changeDirection,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu(
      data: Data.directions,
      change: changeDirection,
      hintText: 'Выберите направление',
    );
  }
}

class _DifficultlyDropdownButton extends StatelessWidget {
  final String difficultly;
  final ValueChanged<String> changeDifficultly;

  const _DifficultlyDropdownButton({
    required this.difficultly,
    required this.changeDifficultly,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu(
      data: Data.difficulties,
      change: changeDifficultly,
      hintText: 'Выберите сложность',
    );
  }
}

class _InterviewButton extends StatelessWidget {
  final String direction;
  final String difficulty;

  const _InterviewButton({required this.direction, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartInterviewBloc, StartInterviewState>(
      listener: (context, state) {
        if (state is StartInterviewLoading) {
          DialogHelper.showLoadingDialog(context, 'Загрузка рекламы');
        } else if (state is StartInterviewSuccess) {
          AppRouter.pop();
          AppRouter.pushReplacementNamed(
            AppRouterNames.interview,
            arguments: InterviewInfo(
              direction: direction,
              difficulty: difficulty,
            ),
          );
        } else if (state is StartInterviewNetworkFailure) {
          AppRouter.pop();
          ToastHelper.networkError();
        } else if (state is StartInterviewNotAttempts) {
          AppRouter.pop();
          ToastHelper.attemptsError();
        } else if (state is StartInterviewFailure) {
          AppRouter.pop();
          ToastHelper.unknownError();
        }
      },
      child: _InterviewButtonView(difficulty: difficulty, direction: direction),
    );
  }
}

class _InterviewButtonView extends StatelessWidget {
  final String difficulty;
  final String direction;

  const _InterviewButtonView({
    required this.difficulty,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.07,
      width: size.width,
      child: difficulty == '' || direction == ''
          ? SizedBox()
          : CustomButton(
              text: 'Начать',
              selectedColor: AppPalette.primary,
              onPressed: () =>
                  context.read<StartInterviewBloc>().add(StartInterview()),
              percentsWidth: 1,
            ),
    );
  }
}
