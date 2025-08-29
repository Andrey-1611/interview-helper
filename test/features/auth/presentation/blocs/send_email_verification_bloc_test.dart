import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/features/auth/domain/use_cases/send_email_verification_use_case.dart';
import 'package:interview_master/features/auth/presentation/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSendEmailVerificationUseCase extends Mock
    implements SendEmailVerificationUseCase {}

void main() {
  late SendEmailVerificationUseCase useCase;
  late SendEmailVerificationBloc mockBloc;

  setUp(() {
    useCase = MockSendEmailVerificationUseCase();
    mockBloc = SendEmailVerificationBloc(useCase);
  });

  tearDown(() => mockBloc.close());

  group('send email verification bloc', () {
    test('initial state', () {
      expect(mockBloc.state, SendEmailVerificationInitial());
    });

    blocTest<SendEmailVerificationBloc, SendEmailVerificationState>(
      'send email verification',
      setUp: () {
        when(() => useCase.call()).thenAnswer((_) async => {});
      },
      build: () => mockBloc,
      act: (bloc) => bloc.add(SendEmailVerification()),
      expect: () => <SendEmailVerificationState>[
        SendEmailVerificationLoading(),
        SendEmailVerificationSuccess(),
      ],
      verify: (_) {
        verify(() => useCase.call()).called(1);
      },
    );
  });
}
