import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/question_choice/question_choice.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Question {
  @JsonKey(required: true)
  late int id;

  @JsonKey(defaultValue: defaultString)
  late String title;

  @JsonKey(defaultValue: defaultString)
  late String questionImage;

  @JsonKey(defaultValue: [])
  late List<QuestionChoice> questionChoices;

  @JsonKey(ignore: true)
  bool isHintApplied = false;

  Question();

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
