// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int?
    ..name = json['name'] as String? ?? ''
    ..country = json['country'] as String? ?? ''
    ..countryFlag = json['country_flag'] as String? ?? ''
    ..profileImage = json['profile_image'] as String?
    ..currentLevel = json['current_level'] as int?
    ..totalCorrectAnswer = json['total_correct_answer'] as int?
    ..totalWrongAnswer = json['total_wrong_answer'] as int?;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'country_flag': instance.countryFlag,
      'profile_image': instance.profileImage,
      'current_level': instance.currentLevel,
      'total_correct_answer': instance.totalCorrectAnswer,
      'total_wrong_answer': instance.totalWrongAnswer,
    };
