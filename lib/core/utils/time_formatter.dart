class TimeFormatter {
  static String time(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    if (minutes > 0) {
      final minutesText = _formatTime(minutes, "минут");
      final secondsText = _formatTime(seconds, "секунд");
      return '$minutesText $secondsText';
    } else {
      return _formatTime(seconds, "секунд");
    }
  }

  static String _formatTime(int value, String unit) {
    if (value == 1) {
      return '$value $unitа';
    } else if (value >= 2 && value <= 4) {
      return '$value $unitы';
    } else {
      return '$value $unit';
    }
  }
}
