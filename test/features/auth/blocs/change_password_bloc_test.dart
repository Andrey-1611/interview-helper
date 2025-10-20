import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/change_password_bloc/change_password_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class FakeMyUser extends Fake implements MyUser {}

void main() {
  late ChangePasswordUseCase useCase;
  late ChangePasswordBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMyUser());
  });

  setUp(() {
    useCase = MockChangePasswordUseCase();
    mockBloc = ChangePasswordBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const name = 'testName';
  const id = 'testId';
  final testUser = MyUser(email: email, name: name, user: id);

  group('change email bloc', () {
    test('initial state', () {
      expect(mockBloc.state, ChangePasswordInitial());
    });

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'change email ',
      setUp: () {
        when(() => useCase.call(any())).thenAnswer((_) async => {});
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(ChangePassword(userBox: testUser)),
      expect: () => <ChangePasswordState>[
        ChangePasswordLoading(),
        ChangePasswordSuccess(),
      ],
      verify: (_) {
        verify(
          () => useCase.call(
            any(
              that: isA<MyUser>()
                  .having((e) => e.email, 'email', email)
                  .having((e) => e.name, 'name', name)
                  .having((e) => e.user, 'id', id),
            ),
          ),
        ).called(1);
      },
    );
  });
}
