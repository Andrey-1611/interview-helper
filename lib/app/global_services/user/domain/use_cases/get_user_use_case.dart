
import '../../data/models/my_user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  Future<MyUser?> call() async {
    return await _userRepository.getUser();
  }
}
