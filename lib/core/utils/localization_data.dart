import '../../generated/l10n.dart';

class LocalizationData {
  final S s;

  LocalizationData(this.s);

  List<String> get types => [s.interviews, s.time, s.score];

  List<String> get languages => [s.russian, s.english];

  static const _interviewsV = 'Interviews';
  static const _timeV = 'Time';
  static const _scoreV = 'Score';

  static const _russianV = 'Russian';
  static const _englishV = 'English';

  String type(String value) => switch (value) {
    _interviewsV => s.interviews,
    _timeV => s.time,
    _scoreV => s.score,
    _ => '?',
  };

  String language(String value) => switch (value) {
    _russianV => s.russian,
    _englishV => s.english,
    _ => s.english,
  };
}
