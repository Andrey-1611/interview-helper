import 'package:json_annotation/json_annotation.dart';

part 'my_user.g.dart';

@JsonSerializable()
class MyUser {
  final String? id;
  final String? name;
  final String email;

  MyUser({this.id, this.name, required this.email,});

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);
  Map<String, dynamic> toJson() => _$MyUserToJson(this);
}
