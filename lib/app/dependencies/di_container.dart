import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/core/global_services/user/services/user_service.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/interview_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/questions_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiContainer {
  static late final AuthDataSource authRepository;
  static late final FirestoreDataSource firestoreRepository;
  static late final InterviewDataSource interviewRepository;
  static late final QuestionsDataSource questionsRepository;
  static late final RemoteDataSource remoteRepository;
  static late final NotificationsService notificationsRepository;
  static late final UserService userRepository;

  static Future<void> init() async {
    authRepository = AuthDataSource(FirebaseAuth.instance);
    firestoreRepository = FirestoreDataSource(FirebaseFirestore.instance);
    interviewRepository = InterviewDataSource();
    questionsRepository = QuestionsDataSource(Random());
    remoteRepository = RemoteDataSource(Gemini.instance);
    notificationsRepository = NotificationsService();
    userRepository = UserService(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  }
}
