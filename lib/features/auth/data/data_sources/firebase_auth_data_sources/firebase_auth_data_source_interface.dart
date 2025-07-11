import 'package:interview_master/features/auth/data/models/user_profile.dart';

abstract interface class FirebaseAuthDataSourceInterface {
  Future<UserProfile?> checkCurrentUser();
  Future<UserProfile> signIn(UserProfile userProfile, String password);
  Future<UserProfile> signUp(UserProfile userProfile, String password);
  Future<void> signOut();
}
