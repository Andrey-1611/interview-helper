import 'package:flutter/material.dart';
import 'package:interview_master/features/interview/views/widgets/custom_button.dart';
import '../../../../app/navigation/app_router.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CustomButton(
          text: 'Выйти из аккаунта',
          selectedColor: Colors.red,
          onPressed: () {
            Navigator.pushNamed(context, AppRouterNames.signUp);
          },
          textColor: Colors.white,
          percentsHeight: 0.1,
          percentsWidth: 0.4,
        ),
      ),
    );
  }
}
