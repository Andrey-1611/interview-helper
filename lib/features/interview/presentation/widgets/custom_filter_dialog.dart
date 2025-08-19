import 'package:flutter/material.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/constants/directions.dart';
import '../../../../core/theme/app_pallete.dart';
import 'custom_button.dart';
import 'custom_dropdown_menu.dart';

class CustomFilterDialog extends StatefulWidget {
  final Function(String, String) runFilter;

  const CustomFilterDialog({super.key, required this.runFilter});

  @override
  State<CustomFilterDialog> createState() => _CustomFilterDialogState();
}

class _CustomFilterDialogState extends State<CustomFilterDialog> {
  String difficulty = '';
  String direction = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DirectionDropdownButton(
            changeDirection: (value) => setState(() {
              direction = value;
            }),
            direction: direction,
          ),
          _DifficultlyDropdownButton(
            difficulty: difficulty,
            changeDifficultly: (value) => setState(() {
              difficulty = value;
            }),
          ),
          _FinishButton(
            runFilter: widget.runFilter,
            direction: direction,
            difficulty: difficulty,
          ),
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
  final Function(String, String) runFilter;
  final String direction;
  final String difficulty;

  const _FinishButton({
    required this.runFilter,
    required this.direction,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Применить',
      selectedColor: AppPalette.primary,
      onPressed: () {
        runFilter(direction, difficulty);
        AppRouter.pop();
      },
      percentsWidth: 1,
    );
  }
}
