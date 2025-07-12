import 'dart:convert';
import 'dart:developer';
import 'package:interview_master/core/global_data_sources/local_data_sources_interface.dart';
import 'package:interview_master/features/auth/data/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource implements LocalDataSourceInterface {
  final SharedPreferences sharedPreferences;
  static const _key = 'user';

  LocalDataSource({required this.sharedPreferences});


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
