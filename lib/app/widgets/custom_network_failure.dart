import 'package:flutter/material.dart';
import 'package:interview_master/generated/l10n.dart';

class CustomNetworkFailure extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomNetworkFailure({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            s.no_internet_connection,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextButton(onPressed: onPressed, child: Text(s.try_again)),
        ],
      ),
    );
  }
}
