import 'package:spense_app/constants.dart';

class BaseResponse {
  late bool isSuccessful;
  dynamic data;
  late String message;

  BaseResponse(Map<String, dynamic> json) {
    isSuccessful = json[keyStatus] as bool;
    data = json.containsKey(keyData) ? json[keyData] : null;
    message = json[keyMessage] as String? ?? defaultString;
  }
}
