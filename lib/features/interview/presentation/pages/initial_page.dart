import 'package:flutter/material.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_button.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return _InitialPageView(
      selectedItem: _selectedItem,
      changeItem: _changeItem,
    );
  }

  void _changeItem(int item) {
    setState(() {
      _selectedItem == item ? _selectedItem = 0 : _selectedItem = item;
    });
  }
}

class _InitialPageView extends StatelessWidget {
  final int selectedItem;
  final ValueChanged<int> changeItem;

  const _InitialPageView({
    required this.selectedItem,
    required this.changeItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _ChooseText(),
            _ChooseForm(selectedItem: selectedItem, changeItem: changeItem),
            const Spacer(),
            _InterviewButton(selectedItem: selectedItem),
          ],
        ),
      ),
    );
  }
}

class _ChooseText extends StatelessWidget {
  const _ChooseText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Выбери сложность',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}

class _ChooseForm extends StatelessWidget {
  final int selectedItem;
  final ValueChanged<int> changeItem;

  const _ChooseForm({required this.selectedItem, required this.changeItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          text: 'Junior',
          selectedColor: color(1),
          percentsHeight: 0.07,
          percentsWidth: 0.24,
          onPressed: () => changeItem(1),
        ),
        CustomButton(
          text: 'Middle',
          selectedColor: color(2),
          percentsHeight: 0.07,
          percentsWidth: 0.24,
          onPressed: () => changeItem(2),
        ),
        CustomButton(
          text: 'Senior',
          selectedColor: color(3),
          percentsHeight: 0.07,
          percentsWidth: 0.24,
          onPressed: () => changeItem(3),
        ),
      ],
    );
  }

  Color color(int item) {
    return selectedItem == item
        ? AppPalette.primary
        : AppPalette.primary.withValues(alpha: 0.2);
  }
}

class _InterviewButton extends StatelessWidget {
  final int selectedItem;

  const _InterviewButton({required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return selectedItem == 0
        ? SizedBox.shrink()
        : CustomButton(
            text: 'Начать',
            selectedColor: Colors.blue,
            onPressed: () {
              AppRouter.pushReplacementNamed(
                AppRouterNames.interview,
                arguments: Interview.difficultly(selectedItem),
              );
            },
            percentsHeight: 0.06,
            percentsWidth: 1,
          );
  }
}
