import 'package:flutter_test/flutter_test.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';
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
  final testUsers = [UserData(name: name, id: id)];

  test('show interviews use case', () async {
    when(() => mockRepository.showUsers()).thenAnswer((_) async => testUsers);

    final users = await useCase.call();

    verify(() => mockRepository.showUsers()).called(1);
    expect(users, testUsers);
  });
}
