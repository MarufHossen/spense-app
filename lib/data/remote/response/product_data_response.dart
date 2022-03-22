import 'package:spense_app/data/remote/model/product/product.dart';
import 'package:spense_app/data/remote/response/base_response.dart';

class ProductDataResponse extends BaseResponse {
  late List<Product> items;

  ProductDataResponse.fromJson(Map<String, dynamic> json) : super(json) {
    items = (data as List<dynamic>?)
            ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }
}
