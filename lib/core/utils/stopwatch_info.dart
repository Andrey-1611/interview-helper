import 'package:injectable/injectable.dart';

@lazySingleton
class StopwatchInfo {
  final Stopwatch _stopwatch;

  StopwatchInfo(this._stopwatch);

  void start() => _stopwatch.start();

  int stop() {
    _stopwatch.stop();
    final time = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    return time;
  }
}
