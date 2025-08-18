import 'package:flutter/material.dart';
import 'package:interview_master/core/constants/directions.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
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
    return _InitialPageView(
      difficultly: difficultly,
      direction: direction,
      changeDirection: _changeDirection,
      changeDifficultly: _changeDifficultly,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DirectionDropdownButton(
              changeDirection: changeDirection,
              direction: direction,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _DifficultlyDropdownButton(
              difficultly: difficultly,
              changeDifficultly: changeDifficultly,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _InterviewButton(difficultly: difficultly, direction: direction),
          ],
        ),
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
      data: InitialData.directions,
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
      data: InitialData.difficulties,
      change: changeDifficultly,
      hintText: 'Выберите сложность',
    );
  }
}

class _InterviewButton extends StatelessWidget {
  final String difficultly;
  final String direction;

  const _InterviewButton({required this.difficultly, required this.direction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.07,
      width: MediaQuery.sizeOf(context).width,
      child: difficultly == '' || direction == ''
          ? SizedBox()
          : CustomButton(
              text: 'Начать',
              selectedColor: AppPalette.primary,
              onPressed: () {
                AppRouter.pushReplacementNamed(
                  AppRouterNames.interview,
                  arguments: InterviewInfo(
                    direction: direction,
                    difficultly: difficultly,
                  ),
                );
              },
              percentsWidth: 1,
            ),
    );
  }
}
