import 'package:injectable/injectable.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/local_repository.dart';

@injectable
class GetUserUseCase {
  final LocalRepository _localRepository;

  GetUserUseCase(this._localRepository);

  Future<UserData> call(UserData? user) async {
    if (user != null) return user;
    return (await _localRepository.getUser())!;
  }
}
