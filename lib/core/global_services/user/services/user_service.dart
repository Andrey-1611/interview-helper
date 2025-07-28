import 'dart:convert';
import 'dart:developer';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService implements UserRepository {
  final SharedPreferences sharedPreferences;
  static const _key = 'user';

  UserService({required this.sharedPreferences});


  @override
  Future<UserProfile?> getUser() async {
    try {
      final userJson = sharedPreferences.getString(_key);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserProfile.fromMap(userMap);
        return user;
      }
      return null;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUser(UserProfile userProfile) async {
    try {
      final userJson = jsonEncode(userProfile.toMap());
      await sharedPreferences.setString(_key, userJson);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> clearUser() async{
    try {
      await sharedPreferences.remove(_key);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
