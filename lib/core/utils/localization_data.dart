import '../../generated/l10n.dart';

class LocalizationData {
  final S s;

  LocalizationData(this.s);

  String get _interviews => s.interviews;

  String get _time => s.time;

  String get _score => s.score;

  List<String> get types => [_interviews, _time, _score];

  static const _interviewsV = 'Interviews';
  static const _timeV = 'Time';
  static const _scoreV = 'Score';

  String type(String value) => switch (value) {
    _interviewsV => s.interviews,
    _timeV => s.time,
    _scoreV => s.score,
    _ => '?',
  };
}
