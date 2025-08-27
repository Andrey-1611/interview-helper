import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:interview_master/features/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:interview_master/features/interview/data/data_sources/chat_gpt_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/gemini_data_source.dart';
import 'package:interview_master/features/interview/data/repositories/ai_repository_impl.dart';
import 'package:interview_master/features/interview/data/repositories/remote_repository_impl.dart';
import 'package:interview_master/features/interview/domain/use_cases/check_results_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_interviews_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';
import '../../features/auth/domain/use_cases/change_email_use_case.dart';
import '../../features/auth/domain/use_cases/send_email_verification_use_case.dart';
import '../../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/watch_email_verified_user_case.dart';
import '../../features/interview/domain/repositories/remote_repository.dart';
import '../../features/interview/domain/repositories/ai_repository.dart';
import '../../features/auth/domain/use_cases/get_user_use_case.dart';

class DIContainer {
  static final AuthRepository _authRepository = AuthRepositoryImpl(
    FirebaseAuthDataSource(FirebaseAuth.instance),
  );
  static final AIRepository _aiRepository = AIRepositoryImpl(
    GeminiDataSource(Gemini.instance),
  );
  static final RemoteRepository _remoteRepository = RemoteRepositoryImpl(
    FirestoreDataSource(FirebaseFirestore.instance),
  );

  static final ChangeEmailUseCase changeEmail = ChangeEmailUseCase(
    _authRepository,
  );

  static final ChangePasswordUseCase changePassword = ChangePasswordUseCase(
    _authRepository,
  );

  static final SendEmailVerificationUseCase sendEmailVerification =
      SendEmailVerificationUseCase(_authRepository);

  static final GetCurrentUserUseCase getCurrentUser = GetCurrentUserUseCase(
    _authRepository,
  );

  static final SignInUseCase signIn = SignInUseCase(_authRepository);

  static final SignOutUseCase signOut = SignOutUseCase(_authRepository);

  static final SignUpUseCase signUp = SignUpUseCase(_authRepository);

  static final WatchEmailVerifiedUseCase watchEmailVerified =
      WatchEmailVerifiedUseCase(_authRepository, _remoteRepository);

  static final CheckResultsUseCase checkResults = CheckResultsUseCase(
    _aiRepository,
    _authRepository,
    _remoteRepository,
  );

  static final ShowInterviewsUseCase showInterviews = ShowInterviewsUseCase(
    _remoteRepository,
  );

  static final ShowUsersUseCase showUsers = ShowUsersUseCase(_remoteRepository);

  static final GetUserUseCase getUser = GetUserUseCase(_authRepository);
}
