import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/core/global_services/user/data/data_sources/firebase_user_data_source.dart';
import 'package:interview_master/core/global_services/user/data/repositories/user_repository_impl.dart';
import 'package:interview_master/core/global_services/user/domain/use_cases/get_user_use_case.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/gemini_data_source.dart';
import 'package:interview_master/features/interview/data/repositories/ai_repository_impl.dart';
import 'package:interview_master/features/interview/data/repositories/remote_repository_impl.dart';
import 'package:interview_master/features/interview/domain/use_cases/add_interview_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/check_resilts_use_case.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_interviews_use_case.dart';
import '../../core/global_services/notifications/services/notifications_repository.dart';
import '../../core/global_services/user/domain/repositories/user_repository.dart';
import '../../features/auth/domain/use_cases/check_email_verified_use_case.dart';
import '../../features/auth/domain/use_cases/delete_account_use_case.dart';
import '../../features/auth/domain/use_cases/send_email_verification_bloc.dart';
import '../../features/auth/domain/use_cases/sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/watch_email_verified_user_case.dart';
import '../../features/interview/domain/repositories/remote_repository.dart';
import '../../features/interview/domain/repositories/ai_repository.dart';

class DIContainer {
  static final UserRepository _userRepository = UserRepositoryImpl(
    FirebaseUserDataSource(FirebaseAuth.instance),
  );
  static final AuthRepository _authRepository = AuthRepositoryImpl(
    FirebaseAuthDataSource(FirebaseAuth.instance),
  );
  static final AIRepository _aiRepository = AIRepositoryImpl(
    GeminiDataSource(Gemini.instance),
  );
  static final RemoteRepository _remoteRepository = RemoteRepositoryImpl(
    FirestoreDataSource(FirebaseFirestore.instance),
  );

  static final ChangePasswordUseCase changePassword = ChangePasswordUseCase(
    _authRepository,
  );
  static final CheckEmailVerifiedUseCase checkEmailVerified =
      CheckEmailVerifiedUseCase(_authRepository);
  static final DeleteAccountUseCase deleteAccount = DeleteAccountUseCase(
    _authRepository,
  );
  static final SendEmailVerificationUseCase sendEmailVerification =
      SendEmailVerificationUseCase(_authRepository);
  static final SignInUseCase signIn = SignInUseCase(_authRepository);
  static final SignOutUseCase signOut = SignOutUseCase(_authRepository);
  static final SignUpUseCase signUp = SignUpUseCase(_authRepository);
  static final WatchEmailVerifiedUseCase watchEmailVerified =
      WatchEmailVerifiedUseCase(_authRepository);

  static final CheckResultsUseCase checkResults = CheckResultsUseCase(
    _aiRepository,
  );
  static final AddInterviewUseCase addInterview = AddInterviewUseCase(
    _remoteRepository,
  );
  static final ShowInterviewsUseCase showInterviews = ShowInterviewsUseCase(
    _remoteRepository,
  );

  static final GetUserUseCase getUser = GetUserUseCase(_userRepository);

  static final NotificationsRepository notificationsRepository =
      NotificationsService();
}
