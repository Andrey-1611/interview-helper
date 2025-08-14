import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository _authRepository;

  GetUserUseCase(this._authRepository);

  Future<MyUser?> call() async {
    return await _authRepository.getUser();
  }
}
