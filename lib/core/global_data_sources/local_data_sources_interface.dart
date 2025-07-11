import 'package:interview_master/features/auth/data/models/user_profile.dart';

abstract interface class LocalDataSourceInterface {
  Future<void> setUser(UserProfile user);

  Future<UserProfile?> getUser();

  Future<void> clearUser();
}
