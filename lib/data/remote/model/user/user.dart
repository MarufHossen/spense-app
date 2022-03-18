import 'package:spense_app/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  @JsonKey(defaultValue: null)
  late int? id;

  @JsonKey(defaultValue: defaultString)
  late String name;

  @JsonKey(defaultValue: defaultString)
  late String country;

  @JsonKey(defaultValue: defaultString)
  late String countryFlag;

  @JsonKey(defaultValue: null)
  late String? profileImage;

  @JsonKey(defaultValue: null)
  late int? currentLevel;

  @JsonKey(defaultValue: null)
  late int? totalCorrectAnswer;

  @JsonKey(defaultValue: null)
  late int? totalWrongAnswer;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
