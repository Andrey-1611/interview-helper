import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';

class GetUserUseCase {
  final LocalRepository _localRepository;

  GetUserUseCase(this._localRepository);

  Future<UserData> call(UserData? user) async {
    if (user != null) return user;
    return (await _localRepository.getUser())!;
  }
}
