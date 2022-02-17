import 'dart:convert';

import '../constants.dart';
import '../enums/api_response_status.dart';
import '../model/booking.dart';
import '../model/scanner_data.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ScannerApi {
  static const String scanHistoryEndpoint = '/scan/history';
  static const String addNewScanEndpoint = '/scan/order/';
  // http post request
  static Future<List<ScannerData>> getAllScanHistory() async {
    http.Response response = await http.get(
        Uri.https(baseApiUrl, scanHistoryEndpoint),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> responseMap = jsonDecode(response.body);

    if (responseMap["status"] == ApiResponseStatus.ok) {
      if (responseMap['data'] != null) {
        List<ScannerData> scanHistory = [];
        responseMap["data"].forEach((v) {
          scanHistory.add(ScannerData.fromJson(v));
        });
        return scanHistory;
      }
    }
    return [];
  }

  static Future<ScannerData?> addNewScannerData(
      String orderId, ScannerData scannerData) async {
    Map<String, String> requestBody = {};
    requestBody["location"] = scannerData.location!;
    requestBody["message"] = scannerData.message!;
    String json = jsonEncode(requestBody);
    http.Response response = await http.post(
        Uri.https(baseApiUrl, addNewScanEndpoint + orderId),
        headers: {"Content-Type": "application/json"},
        body: json);
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    print(responseMap);

    if (responseMap["status"] == ApiResponseStatus.ok) {
      if (responseMap['data'] != null) {
        return ScannerData.fromJson(responseMap["data"]);
      }
    }
    return null;
  }
}
