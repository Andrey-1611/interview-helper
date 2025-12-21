// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(score) => "Точность: ${score}%";

  static String m1(email) => "Письмо с подтвержением отправлено на ${email}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'собеседование', few: 'собеседования', other: 'собеседований')}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'минута', few: 'минуты', other: 'минут')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'минута', few: 'минуты', other: 'минут')}";

  static String m5(password) =>
      "Письмо со сбросом пароля отправлено на ${password}";

  static String m6(count) =>
      "${Intl.plural(count, one: 'очко', few: 'очка', other: 'очков')}";

  static String m7(count) => "Вопрос ${count}";

  static String m8(count) => "${count} вопросов";

  static String m9(count) =>
      "${Intl.plural(count, one: 'секунда', few: 'секунды', other: 'секунд')}";

  static String m10(direction, difficulty, score, url) =>
      "🎯 Мои результаты собеседования\n\n📊 ${direction}, ${difficulty}\n⭐ Результат: ${score}%\n\n🔗 ${url}\n\nСможешь побить? 💪";

  static String m11(time) => "Время: ${time}";

  static String m12(email) => "Почта: ${email}";

  static String m13(name) => "Имя: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accuracy": m0,
    "all_difficulties": MessageLookupByLibrary.simpleMessage("Все сложности"),
    "all_directions": MessageLookupByLibrary.simpleMessage("Все направления"),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Уже есть аккаунт?  Войти в аккаунт",
    ),
    "analysis": MessageLookupByLibrary.simpleMessage("Анализ"),
    "apply": MessageLookupByLibrary.simpleMessage("Применить"),
    "authorization": MessageLookupByLibrary.simpleMessage("Авторизация"),
    "average_score": MessageLookupByLibrary.simpleMessage("Средний результат"),
    "average_time": MessageLookupByLibrary.simpleMessage("Среднее время"),
    "back": MessageLookupByLibrary.simpleMessage("Назад"),
    "back_to_sign_in": MessageLookupByLibrary.simpleMessage(
      "Вернуться на экран входа",
    ),
    "best_score": MessageLookupByLibrary.simpleMessage("Лучший результат"),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "change_password": MessageLookupByLibrary.simpleMessage("Смена пароля"),
    "changing_email": MessageLookupByLibrary.simpleMessage("Смена почты..."),
    "checking_answers": MessageLookupByLibrary.simpleMessage(
      "Проверка ответов...",
    ),
    "choose_difficulty": MessageLookupByLibrary.simpleMessage(
      "Выберите сложность",
    ),
    "choose_direction": MessageLookupByLibrary.simpleMessage(
      "Выберите направление",
    ),
    "choose_language": MessageLookupByLibrary.simpleMessage("Выберите язык"),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "continue_with_google": MessageLookupByLibrary.simpleMessage(
      "Продолжить с Google",
    ),
    "correct_answer": MessageLookupByLibrary.simpleMessage("Правильный ответ:"),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "create_task": MessageLookupByLibrary.simpleMessage("Создать задачу"),
    "created": MessageLookupByLibrary.simpleMessage("Создана"),
    "dark_theme": MessageLookupByLibrary.simpleMessage("Темная тема"),
    "delete_task_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить эту задачу?",
    ),
    "difficulty": MessageLookupByLibrary.simpleMessage("Сложность"),
    "direction": MessageLookupByLibrary.simpleMessage("Направление"),
    "directions": MessageLookupByLibrary.simpleMessage("Направления"),
    "directions_selection": MessageLookupByLibrary.simpleMessage(
      "Выбор направлений",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Почта"),
    "email_not_received": MessageLookupByLibrary.simpleMessage(
      "Не приходит письмо?  Изменить почту",
    ),
    "email_verification": MessageLookupByLibrary.simpleMessage(
      "Подтверждение почты",
    ),
    "email_verification_sent": m1,
    "empty_history": MessageLookupByLibrary.simpleMessage("История пуста"),
    "english": MessageLookupByLibrary.simpleMessage("Английский"),
    "enter_your_answer": MessageLookupByLibrary.simpleMessage(
      "Введите ваш ответ...",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Фильтр"),
    "finish": MessageLookupByLibrary.simpleMessage("Завершить"),
    "firstAverageScore": MessageLookupByLibrary.simpleMessage(
      "Средний результат",
    ),
    "firstBest": MessageLookupByLibrary.simpleMessage("Лучшие"),
    "firstNew": MessageLookupByLibrary.simpleMessage("Новые"),
    "firstOld": MessageLookupByLibrary.simpleMessage("Старые"),
    "firstTotalInterviews": MessageLookupByLibrary.simpleMessage(
      "Собеседования",
    ),
    "firstTotalScore": MessageLookupByLibrary.simpleMessage("Опыт"),
    "firstWorst": MessageLookupByLibrary.simpleMessage("Худшие"),
    "forgot_password_change": MessageLookupByLibrary.simpleMessage(
      "Забыли пароль? Изменить пароль",
    ),
    "general": MessageLookupByLibrary.simpleMessage("Общий"),
    "goal": MessageLookupByLibrary.simpleMessage("Цель"),
    "history": MessageLookupByLibrary.simpleMessage("История"),
    "interview": MessageLookupByLibrary.simpleMessage("Собеседование"),
    "interview_form_error": MessageLookupByLibrary.simpleMessage(
      "Заполните все поля",
    ),
    "interview_word": m2,
    "interviews": MessageLookupByLibrary.simpleMessage("Собеседования"),
    "interviews_count": MessageLookupByLibrary.simpleMessage(
      "Количество собеседований",
    ),
    "library": MessageLookupByLibrary.simpleMessage("Библиотека"),
    "max_time": MessageLookupByLibrary.simpleMessage("Максимальное время"),
    "min_time": MessageLookupByLibrary.simpleMessage("Минимальное время"),
    "minutes_plural": m3,
    "minutes_word": m4,
    "name": MessageLookupByLibrary.simpleMessage("Имя"),
    "network_error": MessageLookupByLibrary.simpleMessage(
      "Нет подключения к интернету",
    ),
    "new_task": MessageLookupByLibrary.simpleMessage("Новая задача"),
    "next": MessageLookupByLibrary.simpleMessage("Дальше"),
    "no": MessageLookupByLibrary.simpleMessage("Нет"),
    "no_account_create": MessageLookupByLibrary.simpleMessage(
      "Еще нет аккаунта?  Создать аккаунт",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "Нет подключения к интернету",
    ),
    "no_tasks_for_filter": MessageLookupByLibrary.simpleMessage(
      "Задач по данному фильтру нет",
    ),
    "no_tasks_yet": MessageLookupByLibrary.simpleMessage("Задач еще нет"),
    "no_users_yet": MessageLookupByLibrary.simpleMessage(
      "Пока нет пользователей",
    ),
    "nothing_found": MessageLookupByLibrary.simpleMessage("Ничего не найдено"),
    "notifications": MessageLookupByLibrary.simpleMessage("Уведомления"),
    "or": MessageLookupByLibrary.simpleMessage("или"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "password_reset_sent": m5,
    "points_word": m6,
    "proceed": MessageLookupByLibrary.simpleMessage("Продолжить"),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "progress": MessageLookupByLibrary.simpleMessage("Прогресс"),
    "question": MessageLookupByLibrary.simpleMessage("Вопрос: "),
    "questionN": m7,
    "question_waiting": MessageLookupByLibrary.simpleMessage(
      "Новый вопрос уже ждёт!",
    ),
    "questions_count": m8,
    "questions_database": MessageLookupByLibrary.simpleMessage("База вопросов"),
    "rate_app": MessageLookupByLibrary.simpleMessage("Оценить приложение"),
    "rating": MessageLookupByLibrary.simpleMessage("Рейтинг"),
    "ready_for_the_interview": MessageLookupByLibrary.simpleMessage(
      "Готов к собеседованию?",
    ),
    "resend_email": MessageLookupByLibrary.simpleMessage(
      "Отправить письмо повторно",
    ),
    "reset_filter": MessageLookupByLibrary.simpleMessage("Сбросить фильтр"),
    "reset_interview_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите сбросить собседование?",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("Русский"),
    "russian_language": MessageLookupByLibrary.simpleMessage("Русский язык"),
    "saving_data": MessageLookupByLibrary.simpleMessage("Сохранение данных..."),
    "score": MessageLookupByLibrary.simpleMessage("Опыт"),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "seconds_plural": m9,
    "select_1_to_3_directions": MessageLookupByLibrary.simpleMessage(
      "Выберите от 1 до 3 направлений",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "share_interview_results": m10,
    "sign_in": MessageLookupByLibrary.simpleMessage("Войти"),
    "sign_in_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка входа, проверьте введенные данные",
    ),
    "sign_out": MessageLookupByLibrary.simpleMessage("Выйти из приложения"),
    "sign_out_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выйти из аккунта?",
    ),
    "sign_up": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
    "signing_in": MessageLookupByLibrary.simpleMessage("Вход в систему..."),
    "signing_out": MessageLookupByLibrary.simpleMessage("Выход из аккаунта..."),
    "similar_information": MessageLookupByLibrary.simpleMessage(
      "Подобная иноформация",
    ),
    "skillai": MessageLookupByLibrary.simpleMessage("SkillAI"),
    "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "start": MessageLookupByLibrary.simpleMessage("Начать"),
    "statistics": MessageLookupByLibrary.simpleMessage("Статистика"),
    "take_interview": MessageLookupByLibrary.simpleMessage(
      "Пройти собеседование",
    ),
    "task_details": MessageLookupByLibrary.simpleMessage("Детали задачи"),
    "task_selector_error": MessageLookupByLibrary.simpleMessage(
      "Заполните все необходимые поля",
    ),
    "time": MessageLookupByLibrary.simpleMessage("Время"),
    "timeT": m11,
    "total_score": MessageLookupByLibrary.simpleMessage(
      "Общее количество очков",
    ),
    "total_time": MessageLookupByLibrary.simpleMessage("Общее время"),
    "tracker": MessageLookupByLibrary.simpleMessage("Трекер"),
    "try_again": MessageLookupByLibrary.simpleMessage("Попробовать еще раз"),
    "type": MessageLookupByLibrary.simpleMessage("Тип"),
    "unknown_error": MessageLookupByLibrary.simpleMessage(
      "Неизвестная ошибка, попробуйте позже",
    ),
    "user": MessageLookupByLibrary.simpleMessage("Пользователь"),
    "user_email": m12,
    "user_name": m13,
    "verify_your_email": MessageLookupByLibrary.simpleMessage(
      "Подтвердите свою почту",
    ),
    "voice": MessageLookupByLibrary.simpleMessage("Озвучка"),
    "yes": MessageLookupByLibrary.simpleMessage("Да"),
    "you": MessageLookupByLibrary.simpleMessage("Вы"),
    "your_answer": MessageLookupByLibrary.simpleMessage("Ваш ответ:"),
  };
}
