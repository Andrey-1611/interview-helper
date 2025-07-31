import 'package:flutter/material.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../data/models/user_input.dart';
import '../widgets/custom_button.dart';

class InterviewFinishPage extends StatefulWidget {
  const InterviewFinishPage({super.key});

  @override
  State<InterviewFinishPage> createState() => _InterviewFinishPageState();
}

class _InterviewFinishPageState extends State<InterviewFinishPage> {
  late final List<String> questions;
  late final List<String> answers;
  late final int difficulty;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AlertDialog(
          title: Text(
            'Вы уверены что хотите завершить тестирование?',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          actions: [
            Center(
              child: CustomButton(
                text: 'Завершить',
                selectedColor: Colors.blue,
                textColor: Colors.white,
                percentsHeight: 0.07,
                percentsWidth: 1,
                onPressed: () {
                  final userInputs = List.generate(
                    10,
                        (index) => UserInput(
                      question: questions[index],
                      answer: answers[index],
                    ),
                  );
                  AppRouter.pushReplacementNamed(
                    AppRouterNames.results,
                    arguments: {
                      'userInputs': userInputs,
                      'difficulty': difficulty,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
