import 'package:flutter/material.dart';
import '../../../../core/navigation/app_router.dart';
import '../widgets/custom_button.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'Выбери сложность',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Row(
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
                    onPressed: () {
                      setState(() {
                        selectedItem == 1 ? selectedItem = 0 : selectedItem = 1;
                      });
                    },
                  ),
                  CustomButton(
                    text: 'Middle',
                    textColor: selectedItem == 2 ? Colors.white : Colors.black,
                    selectedColor:
                        selectedItem == 2 ? Colors.blue : Colors.white,
                    percentsHeight: 0.07,
                    percentsWidth: 0.24,
                    onPressed: () {
                      setState(() {
                        selectedItem == 2 ? selectedItem = 0 : selectedItem = 2;
                      });
                    },
                  ),
                  CustomButton(
                    text: 'Senior',
                    textColor: selectedItem == 3 ? Colors.white : Colors.black,
                    selectedColor:
                        selectedItem == 3 ? Colors.blue : Colors.white,
                    percentsHeight: 0.07,
                    percentsWidth: 0.24,
                    onPressed: () {
                      setState(() {
                        selectedItem == 3 ? selectedItem = 0 : selectedItem = 3;
                      });
                    },
                  ),
                ],
              ),
              Spacer(),
              selectedItem == 0
                  ? SizedBox(height: MediaQuery.sizeOf(context).height * 0.06)
                  : CustomButton(
                    text: 'Начать',
                    selectedColor: Colors.blue,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterNames.interview,
                        arguments: selectedItem,
                      );
                    },
                    textColor: Colors.white,
                    percentsHeight: 0.06,
                    percentsWidth: 1,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
