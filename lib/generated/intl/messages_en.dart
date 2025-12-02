// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(score) => "Accuracy: ${score}%";

  static String m1(email) => "Verification email sent to ${email}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'interview', other: 'interviews')}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'minute', other: 'minutes')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'minute', other: 'minutes')}";

  static String m5(password) => "Password reset email sent to ${password}";

  static String m6(count) =>
      "${Intl.plural(count, one: 'point', other: 'points')}";

  static String m7(count) => "Вопрос ${count}";

  static String m8(count) => "${count} questions";

  static String m9(count) =>
      "${Intl.plural(count, one: 'second', other: 'seconds')}";

  static String m10(direction, difficulty, score, url) =>
      "🎯 My interview results\n\n📊 ${direction}, ${difficulty}\n⭐ Result: ${score}%\n\n🔗 ${url}\n\nCan you beat it? 💪";

  static String m11(time) => "Time: ${time}";

  static String m12(email) => "Email: ${email}";

  static String m13(name) => "Name: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accuracy": m0,
    "all_difficulties": MessageLookupByLibrary.simpleMessage(
      "All difficulties",
    ),
    "all_directions": MessageLookupByLibrary.simpleMessage("All directions"),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Sign in",
    ),
    "analysis": MessageLookupByLibrary.simpleMessage("Analysis"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "attempts_ended": MessageLookupByLibrary.simpleMessage(
      "Attempts ended, come back tomorrow",
    ),
    "authorization": MessageLookupByLibrary.simpleMessage("Authorization"),
    "average_score": MessageLookupByLibrary.simpleMessage("Average score"),
    "average_time": MessageLookupByLibrary.simpleMessage("Average time"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "back_to_email_verification": MessageLookupByLibrary.simpleMessage(
      "Back to email verification",
    ),
    "back_to_sign_in": MessageLookupByLibrary.simpleMessage("Back to sign in"),
    "best_score": MessageLookupByLibrary.simpleMessage("Best score"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "change_email": MessageLookupByLibrary.simpleMessage("Change email"),
    "change_password": MessageLookupByLibrary.simpleMessage("Change password"),
    "changing_email": MessageLookupByLibrary.simpleMessage("Changing email..."),
    "checking_answers": MessageLookupByLibrary.simpleMessage(
      "Checking answers...",
    ),
    "choose_difficulty": MessageLookupByLibrary.simpleMessage(
      "Choose difficulty",
    ),
    "choose_direction": MessageLookupByLibrary.simpleMessage(
      "Choose direction",
    ),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "continue_with_google": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "correct_answer": MessageLookupByLibrary.simpleMessage("Correct answer:"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "create_task": MessageLookupByLibrary.simpleMessage("Create task"),
    "created": MessageLookupByLibrary.simpleMessage("Created"),
    "dark_theme": MessageLookupByLibrary.simpleMessage("Dark theme"),
    "delete_task_confirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this task?",
    ),
    "difficulty": MessageLookupByLibrary.simpleMessage("Difficulty"),
    "direction": MessageLookupByLibrary.simpleMessage("Direction"),
    "directions": MessageLookupByLibrary.simpleMessage("Directions"),
    "directions_selection": MessageLookupByLibrary.simpleMessage(
      "Directions selection",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_not_received": MessageLookupByLibrary.simpleMessage(
      "Email not received? Change email",
    ),
    "email_verification": MessageLookupByLibrary.simpleMessage(
      "Email verification",
    ),
    "email_verification_sent": m1,
    "empty_history": MessageLookupByLibrary.simpleMessage("History is empty"),
    "enter_your_answer": MessageLookupByLibrary.simpleMessage(
      "Enter your answer...",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "finish": MessageLookupByLibrary.simpleMessage("Finish"),
    "firstAverageScore": MessageLookupByLibrary.simpleMessage("Average result"),
    "firstBest": MessageLookupByLibrary.simpleMessage("Best"),
    "firstNew": MessageLookupByLibrary.simpleMessage("New"),
    "firstOld": MessageLookupByLibrary.simpleMessage("Old"),
    "firstTotalInterviews": MessageLookupByLibrary.simpleMessage("Interviews"),
    "firstTotalScore": MessageLookupByLibrary.simpleMessage("Experience"),
    "firstTotalTime": MessageLookupByLibrary.simpleMessage("Time"),
    "firstWorst": MessageLookupByLibrary.simpleMessage("Worst"),
    "forgot_password_change": MessageLookupByLibrary.simpleMessage(
      "Forgot password? Change password",
    ),
    "goal": MessageLookupByLibrary.simpleMessage("Goal"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "interview": MessageLookupByLibrary.simpleMessage("Interview"),
    "interview_form_error": MessageLookupByLibrary.simpleMessage(
      "Please select direction and difficulty",
    ),
    "interview_word": m2,
    "interviews": MessageLookupByLibrary.simpleMessage("Interviews"),
    "interviews_count": MessageLookupByLibrary.simpleMessage(
      "Number of interviews",
    ),
    "library": MessageLookupByLibrary.simpleMessage("Library"),
    "max_time": MessageLookupByLibrary.simpleMessage("Max time"),
    "min_time": MessageLookupByLibrary.simpleMessage("Min time"),
    "minutes_plural": m3,
    "minutes_word": m4,
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "network_error": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "new_task": MessageLookupByLibrary.simpleMessage("New task"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "no_account_create": MessageLookupByLibrary.simpleMessage(
      "No account yet? Create account",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "no_tasks_for_filter": MessageLookupByLibrary.simpleMessage(
      "No tasks for this filter",
    ),
    "no_tasks_yet": MessageLookupByLibrary.simpleMessage("No tasks yet"),
    "nothing_found": MessageLookupByLibrary.simpleMessage("Nothing found"),
    "or": MessageLookupByLibrary.simpleMessage("or"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "password_reset_sent": m5,
    "points_word": m6,
    "proceed": MessageLookupByLibrary.simpleMessage("Continue"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "progress": MessageLookupByLibrary.simpleMessage("Progress"),
    "question": MessageLookupByLibrary.simpleMessage("Question: "),
    "questionN": m7,
    "questions_count": m8,
    "questions_database": MessageLookupByLibrary.simpleMessage(
      "Questions database",
    ),
    "rate_app": MessageLookupByLibrary.simpleMessage("Rate app"),
    "rating": MessageLookupByLibrary.simpleMessage("Rating"),
    "resend_email": MessageLookupByLibrary.simpleMessage("Resend email"),
    "reset_filter": MessageLookupByLibrary.simpleMessage("Reset filter"),
    "reset_interview_confirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to reset the interview?",
    ),
    "russian_language": MessageLookupByLibrary.simpleMessage(
      "Russain language",
    ),
    "saving_data": MessageLookupByLibrary.simpleMessage("Saving data..."),
    "score": MessageLookupByLibrary.simpleMessage("Score"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "seconds_plural": m9,
    "select_1_to_3_directions": MessageLookupByLibrary.simpleMessage(
      "Select from 1 to 3 directions",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share_interview_results": m10,
    "sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
    "sign_in_error": MessageLookupByLibrary.simpleMessage(
      "Sign in error, please check your credentials",
    ),
    "sign_out": MessageLookupByLibrary.simpleMessage("Sign out"),
    "sign_out_confirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to sign out?",
    ),
    "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signing_in": MessageLookupByLibrary.simpleMessage("Signing in..."),
    "signing_out": MessageLookupByLibrary.simpleMessage("Signing out..."),
    "similar_information": MessageLookupByLibrary.simpleMessage(
      "Similar information",
    ),
    "skillai": MessageLookupByLibrary.simpleMessage("SkillAI"),
    "sort": MessageLookupByLibrary.simpleMessage("Sort"),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
    "take_interview": MessageLookupByLibrary.simpleMessage("Take an interview"),
    "task_details": MessageLookupByLibrary.simpleMessage("Task details"),
    "task_selector_error": MessageLookupByLibrary.simpleMessage(
      "Please fill all required fields",
    ),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timeT": m11,
    "total_score": MessageLookupByLibrary.simpleMessage("Total score"),
    "total_time": MessageLookupByLibrary.simpleMessage("Total time"),
    "tracker": MessageLookupByLibrary.simpleMessage("Tracker"),
    "try_again": MessageLookupByLibrary.simpleMessage("Try again"),
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "unknown_error": MessageLookupByLibrary.simpleMessage(
      "Unknown error, please try again later",
    ),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "user_email": m12,
    "user_name": m13,
    "verify_your_email": MessageLookupByLibrary.simpleMessage(
      "Verify your email",
    ),
    "voice": MessageLookupByLibrary.simpleMessage("Voice"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "you": MessageLookupByLibrary.simpleMessage("You"),
    "your_answer": MessageLookupByLibrary.simpleMessage("Your answer:"),
  };
}
