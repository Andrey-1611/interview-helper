import 'package:interview_master/core/global_services/user/models/user_profile.dart';

abstract interface class UserRepository {
  Future<void> setUser(UserProfile user);

  Future<UserProfile?> getUser();

  Future<void> clearUser();
}
