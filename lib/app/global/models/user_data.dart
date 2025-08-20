import 'package:json_annotation/json_annotation.dart';
import '../../../features/auth/data/models/my_user.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String name;
  final String id;

  UserData({required this.name, required this.id});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromMyUser(MyUser user) {
    return UserData(name: user.name!, id: user.id!);
  }
}
