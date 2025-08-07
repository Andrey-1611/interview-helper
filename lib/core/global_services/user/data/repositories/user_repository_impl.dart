import 'package:interview_master/core/global_services/user/data/models/my_user.dart';
import 'package:interview_master/core/global_services/user/domain/repositories/user_repository.dart';

import '../data_sources/firebase_user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserDataSource _firebaseUserDataSource;

  UserRepositoryImpl(this._firebaseUserDataSource);

  @override
  Future<MyUser?> getUser() async {
    return await _firebaseUserDataSource.getUser();
  }
}