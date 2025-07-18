import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interview/presentation/widgets/custom_button.dart';
import '../../blocs/is_email_verified_bloc/is_email_verified_bloc.dart';

class CustomEmailDialog extends StatelessWidget {
  const CustomEmailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтвердите свою почту'),
      actions: [
        CustomButton(
          text: 'Я Подтвердил',
          selectedColor: Colors.blue,
          onPressed: () {
            context.read<IsEmailVerifiedBloc>().add(IsEmailVerified());
            Navigator.pop(context);
          },
          textColor: Colors.white,
          percentsHeight: 0.07,
          percentsWidth: 1,
        ),
      ],
    );
  }
}
