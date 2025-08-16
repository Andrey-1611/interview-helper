import 'package:flutter/material.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_button.dart';

class CustomDirectionsDialog extends StatelessWidget {
  final List<String> directions;

  const CustomDirectionsDialog({super.key, required this.directions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Выбери направление'),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.35,
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: ListView.builder(
          itemCount: directions.length,
          itemBuilder: (context, index) {
            final direction = directions[index];
            return CustomButton(
              text: direction,
              selectedColor: AppPalette.primary,
              onPressed: () {
                AppRouter.pop();
              },
              percentsWidth: 0.24,
            );
          },
        ),
      ),
    );
  }
}
