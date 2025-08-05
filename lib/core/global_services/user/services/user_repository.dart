import 'package:interview_master/core/global_services/user/models/user_profile.dart';

abstract interface class UserRepository {
  Future<UserProfile?> getUser();
}
