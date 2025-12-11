import '../../../data/enums/difficulty.dart';
import '../../../data/enums/language.dart';

abstract class BaseDirection {
  List<String> getRussianQuestions(Difficulty difficulty);

  List<String> getEnglishQuestions(Difficulty difficulty);

  List<String> questions(Language language, Difficulty difficulty) {
    return switch (language) {
      Language.russian => getRussianQuestions(difficulty),
      Language.english => getEnglishQuestions(difficulty),
    };
  }

  List<String> questionsByLanguage(Language language) {
    return [
      ...questions(language, Difficulty.junior),
      ...questions(language, Difficulty.middle),
      ...questions(language, Difficulty.senior),
    ];
  }
}
