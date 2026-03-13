import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

extension Time on Duration {
  String get time {
    final s = S.current;
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);
    if (minutes > 0) {
      final minutesText = '$minutes ${s.minutes_plural(minutes)}';
      final secondsText = '$seconds ${s.seconds_plural(seconds)}';
      return '$minutesText $secondsText';
    } else {
      return '$seconds ${s.seconds_plural(seconds)}';
    }
  }
}

extension DateFormatter on DateTime {
  String get hourFormat => DateFormat('dd.MM.yyyy HH:mm').format(this);

  String get dayFormat => DateFormat('dd.MM.yyyy').format(this);
}
