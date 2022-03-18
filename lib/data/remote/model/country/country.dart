import 'package:spense_app/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Country {
  @JsonKey(defaultValue: defaultString)
  late String name;

  @JsonKey(defaultValue: defaultString)
  late String alpha2Code;

  @JsonKey(defaultValue: defaultString)
  late String flag;

  Country();

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
