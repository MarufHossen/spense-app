// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionChoice _$QuestionChoiceFromJson(Map<String, dynamic> json) {
  return QuestionChoice()
    ..optionName = json['option_name'] as String? ?? ''
    ..isRightOption = json['is_right_option'] as bool? ?? false;
}

Map<String, dynamic> _$QuestionChoiceToJson(QuestionChoice instance) =>
    <String, dynamic>{
      'option_name': instance.optionName,
      'is_right_option': instance.isRightOption,
    };
