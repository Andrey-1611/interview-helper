import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'package:json_annotation/json_annotation.dart';

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
