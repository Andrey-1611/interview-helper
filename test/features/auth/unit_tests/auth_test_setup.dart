import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_test_data.dart';

class AuthTestSetup {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockUser = MockUser();
  final mockUserCredential = MockUserCredential();

  late final FirebaseAuthDataSource dataSource;

  void setUp() {
    _setupWhen();
    dataSource = FirebaseAuthDataSource(mockFirebaseAuth);
  }

  void _setupWhen() {
    when(() => mockUser.email).thenReturn(testEmail);
    when(() => mockUser.displayName).thenReturn(testName);
    when(() => mockUser.uid).thenReturn(testUid);
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(
      () => mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ),
    ).thenAnswer((_) async => mockUserCredential);
    when(
      () => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ),
    ).thenAnswer((_) async => mockUserCredential);
    when(
      () => mockUser.updateDisplayName(testName),
    ).thenAnswer((_) async => Future.value());
    when(() => mockUser.reload()).thenAnswer((_) async => Future.value());

  }
}
