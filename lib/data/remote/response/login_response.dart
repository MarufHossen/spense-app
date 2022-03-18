import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/response/base_response.dart';

class LoginResponse extends BaseResponse {
  late int? userId;

  LoginResponse.fromJson(Map<String, dynamic> json) : super(json) {
    userId = (data as Map<String, dynamic>).containsKey(keyUserId)
        ? data[keyUserId]
        : null;
  }
}
