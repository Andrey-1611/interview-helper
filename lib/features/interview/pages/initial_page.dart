import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/core/utils/stopwatch_info.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import 'package:interview_master/data/repositories/ai_repository.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/features/interview/blocs/interview_bloc/interview_bloc.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_button.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String direction = '';
  String difficulty = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InterviewBloc(
        GetIt.I<AIRepository>(),
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
        GetIt.I<StopwatchInfo>(),
      ),
      child: _InitialPageView(
        difficultly: difficulty,
        direction: direction,
        changeDirection: _changeDirection,
        changeDifficulty: _changeDifficultly,
      ),
    );
  }

  void _changeDirection(String value) => setState(() => direction = value);

  void _changeDifficultly(String value) => setState(() => difficulty = value);
}

class _InitialPageView extends StatelessWidget {
  final String difficultly;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficulty;

  const _InitialPageView({
    required this.difficultly,
    required this.changeDirection,
    required this.changeDifficulty,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text('Собеседование')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomDropdownMenu(
                data: InitialData.directions,
                change: changeDirection,
                hintText: 'Выберите направление',
              ),
              SizedBox(height: size.height * 0.03),
              CustomDropdownMenu(
                data: InitialData.difficulties,
                change: changeDifficulty,
                hintText: 'Выберите сложность',
              ),
              SizedBox(height: size.height * 0.03),
              _InterviewButton(difficulty: difficultly, direction: direction),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterviewButton extends StatelessWidget {
  final String direction;
  final String difficulty;

  const _InterviewButton({required this.direction, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<InterviewBloc, InterviewState>(
      listener: (context, state) {
        if (state is InterviewAttemptsFailure) {
          ToastHelper.attemptsError();
        } else if (state is InterviewNetworkFailure) {
          ToastHelper.networkError();
        } else if (state is InterviewFailure) {
          ToastHelper.unknownError();
        } else if (state is InterviewStartSuccess) {
          context.pushReplacement(
            AppRouterNames.interview,
            extra: InterviewInfo(
              direction: direction,
              difficulty: difficulty,
              userInputs: [],
            ),
          );
        }
      },
      child: SizedBox(
        height: size.height * 0.08,
        width: size.width,
        child: difficulty == '' || direction == ''
            ? SizedBox()
            : CustomButton(
                text: 'Начать',
                selectedColor: AppPalette.primary,
                onPressed: () =>
                    context.read<InterviewBloc>().add(StartInterview()),
              ),
      ),
    );
  }
}
