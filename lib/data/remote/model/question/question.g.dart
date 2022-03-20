// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id']);
  return Question()
    ..id = json['id'] as int
    ..title = json['title'] as String? ?? ''
    ..questionImage = json['question_image'] as String? ?? ''
    ..questionChoices = (json['question_choices'] as List<dynamic>?)
            ?.map((e) => QuestionChoice.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'question_image': instance.questionImage,
      'question_choices': instance.questionChoices,
    };
