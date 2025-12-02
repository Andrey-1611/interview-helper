import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class TimeFormatter {
  static String time(Duration duration, BuildContext context) {
    final s = S.of(context);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    if (minutes > 0) {
      final minutesText = '$minutes ${s.minutes_plural(minutes)}';
      final secondsText = '$seconds ${s.seconds_plural(seconds)}';
      return '$minutesText $secondsText';
    } else {
      return '$seconds ${s.seconds_plural(seconds)}';
    }
  }
}
