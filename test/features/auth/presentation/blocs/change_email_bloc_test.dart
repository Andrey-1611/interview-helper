import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/domain/use_cases/change_email_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/change_email_bloc/change_email_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockChangeEmailUseCase extends Mock implements ChangeEmailUseCase {}

void main() {
  late ChangeEmailUseCase useCase;
  late ChangeEmailBloc mockBloc;

  setUp(() {
    useCase = MockChangeEmailUseCase();
    mockBloc = ChangeEmailBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  const email = 'testEmail';
  const password = 'testPassword';

  group('change email bloc', () {
    test('initial state', () {
      expect(mockBloc.state, ChangeEmailInitial());
    });

    blocTest<ChangeEmailBloc, ChangeEmailState>(
      'change email',
      setUp: () {
        when(() => useCase.call(email, password)).thenAnswer((_) async => {});
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(ChangeEmail(email: email, password: password)),
      expect: () => <ChangeEmailState>[
        ChangeEmailLoading(),
        ChangeEmailSuccess(),
      ],
      verify: (_) {
        verify(() => useCase.call(email, password)).called(1);
      },
    );
  });
}
