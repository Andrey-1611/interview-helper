// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Interview`
  String get interview {
    return Intl.message('Interview', name: 'interview', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Tracker`
  String get tracker {
    return Intl.message('Tracker', name: 'tracker', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `SkillAI`
  String get skillai {
    return Intl.message('SkillAI', name: 'skillai', desc: '', args: []);
  }

  /// `Change email`
  String get change_email {
    return Intl.message(
      'Change email',
      name: 'change_email',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Back to email verification`
  String get back_to_email_verification {
    return Intl.message(
      'Back to email verification',
      name: 'back_to_email_verification',
      desc: '',
      args: [],
    );
  }

  /// `Changing email...`
  String get changing_email {
    return Intl.message(
      'Changing email...',
      name: 'changing_email',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Back to sign in`
  String get back_to_sign_in {
    return Intl.message(
      'Back to sign in',
      name: 'back_to_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Email verification`
  String get email_verification {
    return Intl.message(
      'Email verification',
      name: 'email_verification',
      desc: '',
      args: [],
    );
  }

  /// `Resend email`
  String get resend_email {
    return Intl.message(
      'Resend email',
      name: 'resend_email',
      desc: '',
      args: [],
    );
  }

  /// `Email not received? Change email`
  String get email_not_received {
    return Intl.message(
      'Email not received? Change email',
      name: 'email_not_received',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email`
  String get verify_your_email {
    return Intl.message(
      'Verify your email',
      name: 'verify_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Signing in...`
  String get signing_in {
    return Intl.message(
      'Signing in...',
      name: 'signing_in',
      desc: '',
      args: [],
    );
  }

  /// `No account yet? Create account`
  String get no_account_create {
    return Intl.message(
      'No account yet? Create account',
      name: 'no_account_create',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot password? Change password`
  String get forgot_password_change {
    return Intl.message(
      'Forgot password? Change password',
      name: 'forgot_password_change',
      desc: '',
      args: [],
    );
  }

  /// `Authorization`
  String get authorization {
    return Intl.message(
      'Authorization',
      name: 'authorization',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Sign in`
  String get already_have_account {
    return Intl.message(
      'Already have an account? Sign in',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message('Sign up', name: 'sign_up', desc: '', args: []);
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message('Sign in', name: 'sign_in', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Nothing found`
  String get nothing_found {
    return Intl.message(
      'Nothing found',
      name: 'nothing_found',
      desc: '',
      args: [],
    );
  }

  /// `Choose direction`
  String get choose_direction {
    return Intl.message(
      'Choose direction',
      name: 'choose_direction',
      desc: '',
      args: [],
    );
  }

  /// `Choose difficulty`
  String get choose_difficulty {
    return Intl.message(
      'Choose difficulty',
      name: 'choose_difficulty',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Question: `
  String get question {
    return Intl.message('Question: ', name: 'question', desc: '', args: []);
  }

  /// `Enter your answer...`
  String get enter_your_answer {
    return Intl.message(
      'Enter your answer...',
      name: 'enter_your_answer',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Are you sure you want to reset the interview?`
  String get reset_interview_confirmation {
    return Intl.message(
      'Are you sure you want to reset the interview?',
      name: 'reset_interview_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Questions database`
  String get questions_database {
    return Intl.message(
      'Questions database',
      name: 'questions_database',
      desc: '',
      args: [],
    );
  }

  /// `{count} questions`
  String questions_count(Object count) {
    return Intl.message(
      '$count questions',
      name: 'questions_count',
      desc: '',
      args: [count],
    );
  }

  /// `Checking answers...`
  String get checking_answers {
    return Intl.message(
      'Checking answers...',
      name: 'checking_answers',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message('or', name: 'or', desc: '', args: []);
  }

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message('Statistics', name: 'statistics', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Library`
  String get library {
    return Intl.message('Library', name: 'library', desc: '', args: []);
  }

  /// `Direction`
  String get direction {
    return Intl.message('Direction', name: 'direction', desc: '', args: []);
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message('Difficulty', name: 'difficulty', desc: '', args: []);
  }

  /// `Sort`
  String get sort {
    return Intl.message('Sort', name: 'sort', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Accuracy: {score}%`
  String accuracy(Object score) {
    return Intl.message(
      'Accuracy: $score%',
      name: 'accuracy',
      desc: '',
      args: [score],
    );
  }

  /// `Your answer:`
  String get your_answer {
    return Intl.message(
      'Your answer:',
      name: 'your_answer',
      desc: '',
      args: [],
    );
  }

  /// `Correct answer:`
  String get correct_answer {
    return Intl.message(
      'Correct answer:',
      name: 'correct_answer',
      desc: '',
      args: [],
    );
  }

  /// `Вопрос {count}`
  String questionN(Object count) {
    return Intl.message(
      'Вопрос $count',
      name: 'questionN',
      desc: '',
      args: [count],
    );
  }

  /// `History is empty`
  String get empty_history {
    return Intl.message(
      'History is empty',
      name: 'empty_history',
      desc: '',
      args: [],
    );
  }

  /// `Reset filter`
  String get reset_filter {
    return Intl.message(
      'Reset filter',
      name: 'reset_filter',
      desc: '',
      args: [],
    );
  }

  /// `Take an interview`
  String get take_interview {
    return Intl.message(
      'Take an interview',
      name: 'take_interview',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Signing out...`
  String get signing_out {
    return Intl.message(
      'Signing out...',
      name: 'signing_out',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Name: {name}`
  String user_name(Object name) {
    return Intl.message(
      'Name: $name',
      name: 'user_name',
      desc: '',
      args: [name],
    );
  }

  /// `Email: {email}`
  String user_email(Object email) {
    return Intl.message(
      'Email: $email',
      name: 'user_email',
      desc: '',
      args: [email],
    );
  }

  /// `Voice`
  String get voice {
    return Intl.message('Voice', name: 'voice', desc: '', args: []);
  }

  /// `Dark theme`
  String get dark_theme {
    return Intl.message('Dark theme', name: 'dark_theme', desc: '', args: []);
  }

  /// `Rate app`
  String get rate_app {
    return Intl.message('Rate app', name: 'rate_app', desc: '', args: []);
  }

  /// `Sign out`
  String get sign_out {
    return Intl.message('Sign out', name: 'sign_out', desc: '', args: []);
  }

  /// `Are you sure you want to sign out?`
  String get sign_out_confirmation {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'sign_out_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Select from 1 to 3 directions`
  String get select_1_to_3_directions {
    return Intl.message(
      'Select from 1 to 3 directions',
      name: 'select_1_to_3_directions',
      desc: '',
      args: [],
    );
  }

  /// `Directions selection`
  String get directions_selection {
    return Intl.message(
      'Directions selection',
      name: 'directions_selection',
      desc: '',
      args: [],
    );
  }

  /// `Task details`
  String get task_details {
    return Intl.message(
      'Task details',
      name: 'task_details',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message('Progress', name: 'progress', desc: '', args: []);
  }

  /// `Created`
  String get created {
    return Intl.message('Created', name: 'created', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `No tasks yet`
  String get no_tasks_yet {
    return Intl.message(
      'No tasks yet',
      name: 'no_tasks_yet',
      desc: '',
      args: [],
    );
  }

  /// `Create task`
  String get create_task {
    return Intl.message('Create task', name: 'create_task', desc: '', args: []);
  }

  /// `No tasks for this filter`
  String get no_tasks_for_filter {
    return Intl.message(
      'No tasks for this filter',
      name: 'no_tasks_for_filter',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this task?`
  String get delete_task_confirmation {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'delete_task_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `New task`
  String get new_task {
    return Intl.message('New task', name: 'new_task', desc: '', args: []);
  }

  /// `Goal`
  String get goal {
    return Intl.message('Goal', name: 'goal', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Saving data...`
  String get saving_data {
    return Intl.message(
      'Saving data...',
      name: 'saving_data',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get proceed {
    return Intl.message('Continue', name: 'proceed', desc: '', args: []);
  }

  /// `Analysis`
  String get analysis {
    return Intl.message('Analysis', name: 'analysis', desc: '', args: []);
  }

  /// `You`
  String get you {
    return Intl.message('You', name: 'you', desc: '', args: []);
  }

  /// `Number of interviews`
  String get interviews_count {
    return Intl.message(
      'Number of interviews',
      name: 'interviews_count',
      desc: '',
      args: [],
    );
  }

  /// `Total score`
  String get total_score {
    return Intl.message('Total score', name: 'total_score', desc: '', args: []);
  }

  /// `Average score`
  String get average_score {
    return Intl.message(
      'Average score',
      name: 'average_score',
      desc: '',
      args: [],
    );
  }

  /// `Best score`
  String get best_score {
    return Intl.message('Best score', name: 'best_score', desc: '', args: []);
  }

  /// `Total time`
  String get total_time {
    return Intl.message('Total time', name: 'total_time', desc: '', args: []);
  }

  /// `Average time`
  String get average_time {
    return Intl.message(
      'Average time',
      name: 'average_time',
      desc: '',
      args: [],
    );
  }

  /// `All difficulties`
  String get all_difficulties {
    return Intl.message(
      'All difficulties',
      name: 'all_difficulties',
      desc: '',
      args: [],
    );
  }

  /// `All directions`
  String get all_directions {
    return Intl.message(
      'All directions',
      name: 'all_directions',
      desc: '',
      args: [],
    );
  }

  /// `Similar information`
  String get similar_information {
    return Intl.message(
      'Similar information',
      name: 'similar_information',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get directions {
    return Intl.message('Directions', name: 'directions', desc: '', args: []);
  }

  /// `Interviews`
  String get interviews {
    return Intl.message('Interviews', name: 'interviews', desc: '', args: []);
  }

  /// `Max time`
  String get max_time {
    return Intl.message('Max time', name: 'max_time', desc: '', args: []);
  }

  /// `Min time`
  String get min_time {
    return Intl.message('Min time', name: 'min_time', desc: '', args: []);
  }

  /// `Verification email sent to {email}`
  String email_verification_sent(Object email) {
    return Intl.message(
      'Verification email sent to $email',
      name: 'email_verification_sent',
      desc: '',
      args: [email],
    );
  }

  /// `Password reset email sent to {password}`
  String password_reset_sent(Object password) {
    return Intl.message(
      'Password reset email sent to $password',
      name: 'password_reset_sent',
      desc: '',
      args: [password],
    );
  }

  /// `Sign in error, please check your credentials`
  String get sign_in_error {
    return Intl.message(
      'Sign in error, please check your credentials',
      name: 'sign_in_error',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error, please try again later`
  String get unknown_error {
    return Intl.message(
      'Unknown error, please try again later',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get network_error {
    return Intl.message(
      'No internet connection',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Attempts ended, come back tomorrow`
  String get attempts_ended {
    return Intl.message(
      'Attempts ended, come back tomorrow',
      name: 'attempts_ended',
      desc: '',
      args: [],
    );
  }

  /// `Please select direction and difficulty`
  String get interview_form_error {
    return Intl.message(
      'Please select direction and difficulty',
      name: 'interview_form_error',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all required fields`
  String get task_selector_error {
    return Intl.message(
      'Please fill all required fields',
      name: 'task_selector_error',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{interview} other{interviews}}`
  String interview_word(num count) {
    return Intl.plural(
      count,
      one: 'interview',
      other: 'interviews',
      name: 'interview_word',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{minute} other{minutes}}`
  String minutes_word(num count) {
    return Intl.plural(
      count,
      one: 'minute',
      other: 'minutes',
      name: 'minutes_word',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{point} other{points}}`
  String points_word(num count) {
    return Intl.plural(
      count,
      one: 'point',
      other: 'points',
      name: 'points_word',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{minute} other{minutes}}`
  String minutes_plural(num count) {
    return Intl.plural(
      count,
      one: 'minute',
      other: 'minutes',
      name: 'minutes_plural',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{second} other{seconds}}`
  String seconds_plural(num count) {
    return Intl.plural(
      count,
      one: 'second',
      other: 'seconds',
      name: 'seconds_plural',
      desc: '',
      args: [count],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `No internet connection`
  String get no_internet_connection {
    return Intl.message(
      'No internet connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get try_again {
    return Intl.message('Try again', name: 'try_again', desc: '', args: []);
  }

  /// `🎯 My interview results\n\n📊 {direction}, {difficulty}\n⭐ Result: {score}%\n\n🔗 {url}\n\nCan you beat it? 💪`
  String share_interview_results(
    Object direction,
    Object difficulty,
    Object score,
    Object url,
  ) {
    return Intl.message(
      '🎯 My interview results\n\n📊 $direction, $difficulty\n⭐ Result: $score%\n\n🔗 $url\n\nCan you beat it? 💪',
      name: 'share_interview_results',
      desc: '',
      args: [direction, difficulty, score, url],
    );
  }

  /// `Time: {time}`
  String timeT(Object time) {
    return Intl.message('Time: $time', name: 'timeT', desc: '', args: [time]);
  }

  /// `Russain language`
  String get russian_language {
    return Intl.message(
      'Russain language',
      name: 'russian_language',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get firstNew {
    return Intl.message('New', name: 'firstNew', desc: '', args: []);
  }

  /// `Old`
  String get firstOld {
    return Intl.message('Old', name: 'firstOld', desc: '', args: []);
  }

  /// `Best`
  String get firstBest {
    return Intl.message('Best', name: 'firstBest', desc: '', args: []);
  }

  /// `Worst`
  String get firstWorst {
    return Intl.message('Worst', name: 'firstWorst', desc: '', args: []);
  }

  /// `Experience`
  String get firstTotalScore {
    return Intl.message(
      'Experience',
      name: 'firstTotalScore',
      desc: '',
      args: [],
    );
  }

  /// `Interviews`
  String get firstTotalInterviews {
    return Intl.message(
      'Interviews',
      name: 'firstTotalInterviews',
      desc: '',
      args: [],
    );
  }

  /// `Average result`
  String get firstAverageScore {
    return Intl.message(
      'Average result',
      name: 'firstAverageScore',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get firstTotalTime {
    return Intl.message('Time', name: 'firstTotalTime', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Score`
  String get score {
    return Intl.message('Score', name: 'score', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
