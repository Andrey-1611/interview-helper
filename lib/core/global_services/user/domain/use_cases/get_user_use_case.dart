import 'package:interview_master/core/global_services/user/data/models/my_user.dart';
import 'package:interview_master/core/global_services/user/domain/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  Future<MyUser?> call() async {
    return await _userRepository.getUser();
  }
}
