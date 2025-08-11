import '../../data/models/my_user.dart';

abstract interface class UserRepository {
  Future<MyUser?> getUser();
}
