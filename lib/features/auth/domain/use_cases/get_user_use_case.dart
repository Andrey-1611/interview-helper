import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import '../../data/models/my_user.dart';

class GetUserUseCase {
  final LocalRepository _localRepository;

  GetUserUseCase(this._localRepository);

  Future<MyUser> call() async {
    final user = await _localRepository.getUser();
    return user!;
  }
}
