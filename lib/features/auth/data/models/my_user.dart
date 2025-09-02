import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_user.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class MyUser extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String email;

  const MyUser({this.id, this.name, required this.email});

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyUserToJson(this);

  @override
  List<Object?> get props => [id, name, email];
}
