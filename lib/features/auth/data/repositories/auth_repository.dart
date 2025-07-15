import 'package:interview_master/core/global_services/user/models/user_profile.dart';

abstract interface class AuthRepository {
  Future<UserProfile?> checkCurrentUser();
  Future<UserProfile> signIn(UserProfile userProfile, String password);
  Future<UserProfile> signUp(UserProfile userProfile, String password);
  Future<void> signOut();
}
