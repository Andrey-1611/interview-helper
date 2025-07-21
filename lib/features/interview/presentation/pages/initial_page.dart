import 'package:flutter/material.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
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
    return _InitialPageView(selectedItem: _selectedItem, changeItem: _changeItem,);
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
  const _InitialPageView({required this.selectedItem, required this.changeItem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
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
          textColor: selectedItem == 1 ? Colors.white : Colors.black,
          selectedColor:
          selectedItem == 1 ? Colors.blue : Colors.white,
          percentsHeight: 0.07,
          percentsWidth: 0.24,
          onPressed: () => changeItem(1),
        ),
        CustomButton(
          text: 'Middle',
          textColor: selectedItem == 2 ? Colors.white : Colors.black,
          selectedColor:
          selectedItem == 2 ? Colors.blue : Colors.white,
          percentsHeight: 0.07,
          percentsWidth: 0.24,
          onPressed: () => changeItem(2),
        ),
        CustomButton(
          text: 'Senior',
          textColor: selectedItem == 3 ? Colors.white : Colors.black,
          selectedColor:
          selectedItem == 3 ? Colors.blue : Colors.white,
          percentsHeight: 0.07,
          percentsWidth: 0.24,
          onPressed: () => changeItem(3),
        ),
      ],
    );
  }
}


class _InterviewButton extends StatelessWidget {
  final int selectedItem;
  const _InterviewButton({required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return selectedItem == 0
        ? SizedBox(height: MediaQuery.sizeOf(context).height * 0.06)
        : CustomButton(
      text: 'Начать',
      selectedColor: Colors.blue,
      onPressed: () {
        AppRouter.pushReplacementNamed(
          AppRouterNames.interview,
          arguments: selectedItem,
        );
      },
      textColor: Colors.white,
      percentsHeight: 0.06,
      percentsWidth: 1,
    );
  }
}
