import 'package:spense_app/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Product {
  @JsonKey(defaultValue: defaultInt)
  late int id;

  @JsonKey(defaultValue: defaultString)
  late String productName;

  @JsonKey(defaultValue: defaultString)
  late String productId;

  @JsonKey(defaultValue: defaultDouble)
  late double price;

  @JsonKey(defaultValue: defaultString)
  late String status;

  Product();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
