import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/sign_out_bloc/sign_out_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late SignOutUseCase useCase;
  late SignOutBloc mockBloc;

  setUp(() {
    useCase = MockSignOutUseCase();
    mockBloc = SignOutBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  group('sign out bloc', () {
    test('initial state', () {
      expect(mockBloc.state, SignOutInitial());
    });

    blocTest<SignOutBloc, SignOutState>(
      'sign out',
      setUp: () {
        when(() => useCase.call()).thenAnswer((_) async => {});
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(SignOut()),
      expect: () => <SignOutState>[SignOutLoading(), SignOutSuccess()],
      verify: (_) {
        verify(() => useCase.call()).called(1);
      },
    );
  });
}
