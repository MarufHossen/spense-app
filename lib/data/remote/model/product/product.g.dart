// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product()
    ..id = json['id'] as int? ?? 0
    ..productName = json['product_name'] as String? ?? ''
    ..productId = json['product_id'] as String? ?? ''
    ..price = (json['price'] as num?)?.toDouble() ?? 0.0
    ..status = json['status'] as String? ?? '';
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'product_id': instance.productId,
      'price': instance.price,
      'status': instance.status,
    };
