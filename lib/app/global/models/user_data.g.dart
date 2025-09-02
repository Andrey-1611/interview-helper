// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      name: json['name'] as String,
      id: json['id'] as String,
      totalInterviews: (json['totalInterviews'] as num).toInt(),
      totalScore: (json['totalScore'] as num).toInt(),
      averageScore: (json['averageScore'] as num).toInt(),
      bestScore: (json['bestScore'] as num).toInt(),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'totalInterviews': instance.totalInterviews,
      'totalScore': instance.totalScore,
      'averageScore': instance.averageScore,
      'bestScore': instance.bestScore,
    };
