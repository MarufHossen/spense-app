import 'package:spense_app/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question_choice.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class QuestionChoice {
  @JsonKey(defaultValue: defaultString)
  late String optionName;

  @JsonKey(defaultValue: defaultBoolean)
  late bool isRightOption;

  @JsonKey(ignore: true)
  bool isActive = true;

  QuestionChoice();

  factory QuestionChoice.fromJson(Map<String, dynamic> json) =>
      _$QuestionChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionChoiceToJson(this);
}
