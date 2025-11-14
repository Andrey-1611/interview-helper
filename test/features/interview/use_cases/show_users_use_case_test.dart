import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/domain/repositories/remote.dart';
import 'package:interview_master/features/users/use_cases/show_users_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}

void main() {
  late ShowUsersUseCase useCase;
  late RemoteRepository mockRepository;

  setUp(() {
    mockRepository = MockRemoteRepository();
    useCase = ShowUsersUseCase(mockRepository);
  });

  const name = 'testName';
  const id = 'testId';
  const totalInterviews = 0;
  const totalScore = 0;
  const averageScore = 0;
  const bestScore = 0;

  final testUsers = [
    UserData(
      name: name,
      profile: id,
      totalInterviews: totalInterviews,
      totalScore: totalScore,
      averageScore: averageScore,
      bestScore: bestScore,
    ),
  ];

  test('show interviews use case', () async {
    when(() => mockRepository.getUsers()).thenAnswer((_) async => testUsers);

    final users = await useCase.call();

    verify(() => mockRepository.getUsers()).called(1);
    expect(users, testUsers);
  });
}
