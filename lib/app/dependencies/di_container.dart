import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/core/global_services/user/services/user_service.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/interview_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/remote_data_source.dart';
import 'package:interview_master/features/interview/data/repositories/questions_repository.dart';
import '../../core/global_services/notifications/services/notifications_repository.dart';
import '../../core/global_services/user/services/user_repository.dart';
import '../../features/auth/domain/use_cases/check_email_verified_use_case.dart';
import '../../features/auth/domain/use_cases/delete_account_use_case.dart';
import '../../features/auth/domain/use_cases/send_email_verification_bloc.dart';
import '../../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/watch_email_verified_user_case.dart';
import '../../features/interview/data/data_sources/questions_data_source.dart';
import '../../features/interview/data/repositories/firestore_repository.dart';
import '../../features/interview/data/repositories/interview_repository.dart';
import '../../features/interview/data/repositories/remote_repository.dart';

class DIContainer {
  static final AuthRepository authRepository = AuthRepositoryImpl(
    AuthDataSource(FirebaseAuth.instance),
  );
  static final ChangePasswordUseCase changePassword = ChangePasswordUseCase(authRepository);
  static final CheckEmailVerifiedUseCase checkEmailVerified = CheckEmailVerifiedUseCase(authRepository);
  static final DeleteAccountUseCase deleteAccount = DeleteAccountUseCase(authRepository);
  static final SendEmailVerificationUseCase sendEmailVerification = SendEmailVerificationUseCase(authRepository);
  static final SignInUseCase signIn = SignInUseCase(authRepository);
  static final SignOutUseCase signOut = SignOutUseCase(authRepository);
  static final SignUpUseCase signUp = SignUpUseCase(authRepository);
  static final WatchEmailVerifiedUseCase watchEmailVerified = WatchEmailVerifiedUseCase(authRepository);

  static final NotificationsRepository notificationsRepository = NotificationsService();
  static final UserRepository userRepository = UserService(FirebaseAuth.instance);
  static final FirestoreRepository firestoreRepository = FirestoreDataSource(FirebaseFirestore.instance);
  static final InterviewRepository interviewRepository = InterviewDataSource();
  static final QuestionsRepository questionsRepository = QuestionsDataSource(Random());
  static final RemoteRepository remoteRepository = RemoteDataSource(Gemini.instance);
}
