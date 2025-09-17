import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_user.g.dart';

@JsonSerializable()
class MyUser extends Equatable {
  final String? id;
  final String? name;
  final String email;

  const MyUser({this.id, this.name, required this.email});

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyUserToJson(this);

  @override
  List<Object?> get props => [id, name, email];
}
