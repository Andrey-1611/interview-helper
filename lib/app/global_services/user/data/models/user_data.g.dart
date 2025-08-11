// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  name: json['name'] as String,
  id: json['id'] as String,
  interviews: (json['interviews'] as List<dynamic>)
      .map((e) => Interview.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'name': instance.name,
  'id': instance.id,
  'interviews': instance.interviews,
};
