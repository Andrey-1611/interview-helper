import '../../domain/repositories/user_repository.dart';
import '../data_sources/firebase_user_data_source.dart';
import '../models/my_user.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserDataSource _firebaseUserDataSource;

  UserRepositoryImpl(this._firebaseUserDataSource);

  @override
  Future<MyUser?> getUser() async {
    return await _firebaseUserDataSource.getUser();
  }
}