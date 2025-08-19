import 'package:flutter/material.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/constants/directions.dart';
import '../../../../core/theme/app_pallete.dart';
import 'custom_button.dart';
import 'custom_dropdown_menu.dart';

class CustomFilterDialog extends StatelessWidget {
  final String difficulty;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficultly;

  const CustomFilterDialog({
    super.key,
    required this.difficulty,
    required this.direction,
    required this.changeDirection,
    required this.changeDifficultly,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DirectionDropdownButton(
              changeDirection: changeDirection,
              direction: direction,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _DifficultlyDropdownButton(
              difficulty: difficulty,
              changeDifficultly: changeDifficultly,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _FinishButton(),
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
      hintText: 'Все направления',
    );
  }
}

class _DifficultlyDropdownButton extends StatelessWidget {
  final String difficulty;
  final ValueChanged<String> changeDifficultly;

  const _DifficultlyDropdownButton({
    required this.difficulty,
    required this.changeDifficultly,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu(
      data: InitialData.difficulties,
      change: changeDifficultly,
      hintText: 'Все Cложности',
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Применить',
      selectedColor: AppPalette.primary,
      onPressed: () => AppRouter.pop(),
      percentsWidth: 1,
    );
  }
}
