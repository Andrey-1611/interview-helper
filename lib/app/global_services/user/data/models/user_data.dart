import 'package:json_annotation/json_annotation.dart';
import '../../../../../features/interview/data/models/interview.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String name;
  final String id;
  final List<Interview> interviews;

  UserData({required this.name, required this.id, required this.interviews});

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
