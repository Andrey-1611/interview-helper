import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_repository.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';
import 'package:interview_master/core/global_services/user/services/user_service.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/interview_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/questions_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/remote_data_source.dart';
import 'package:interview_master/features/interview/data/repositories/firestore_repository.dart';
import 'package:interview_master/features/interview/data/repositories/interview_repository.dart';
import 'package:interview_master/features/interview/data/repositories/questions_repository.dart';
import 'package:interview_master/features/interview/data/repositories/remote_repository.dart';

class GlobalBlocProvider extends StatelessWidget {
  final Widget child;

  const GlobalBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationsRepository>(
          create: (_) => NotificationsService(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserService(FirebaseAuth.instance),
        ),
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthDataSource(FirebaseAuth.instance),
        ),
        RepositoryProvider<FirestoreRepository>(
          create: (_) => FirestoreDataSource(FirebaseFirestore.instance),
        ),
        RepositoryProvider<InterviewRepository>(
          create: (_) => InterviewDataSource(),
        ),
        RepositoryProvider<QuestionsRepository>(
          create: (_) => QuestionsDataSource(Random()),
        ),
        RepositoryProvider<RemoteRepository>(
          create: (_) => RemoteDataSource(Gemini.instance),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SendNotificationBloc(context.read<NotificationsRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }
}
