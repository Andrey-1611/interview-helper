import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/use_cases/watch_email_verified_user_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/watch_email_verified_bloc/watch_email_verified_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchEmailVerifiedUseCase extends Mock
    implements WatchEmailVerifiedUseCase {}

void main() {
  late WatchEmailVerifiedUseCase useCase;
  late WatchEmailVerifiedBloc mockBloc;

  setUp(() {
    useCase = MockWatchEmailVerifiedUseCase();
    mockBloc = WatchEmailVerifiedBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, profile: id);

  group('watch email verified bloc', () {
    test('initial state', () {
      expect(mockBloc.state, WatchEmailVerifiedInitial());
    });

    blocTest<WatchEmailVerifiedBloc, WatchEmailVerifiedState>(
      'watch email verified',
      setUp: () {
        when(() => useCase.call()).thenAnswer((_) async => testUser);
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(WatchEmailVerified()),
      expect: () => <WatchEmailVerifiedState>[
        WatchEmailVerifiedLoading(),
        WatchEmailVerifiedSuccess(userBox: testUser),
      ],
      verify: (_) {
        verify(() => useCase.call()).called(1);
      },
    );
  });
}
