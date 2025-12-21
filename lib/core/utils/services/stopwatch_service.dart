class StopwatchService {
  final Stopwatch _stopwatch;

  StopwatchService(this._stopwatch);

  void start() => _stopwatch.start();

  int stop() {
    _stopwatch.stop();
    final time = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();
    return time;
  }
}
