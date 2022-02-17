import 'dart:convert';

import '../constants.dart';
import '../enums/api_response_status.dart';
import '../model/booking.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class BookingApi {
  static const String scoroBookingsEndpointParam = '/booking/list';
  static const String allPrintedBookingsEndpointParam = '/booking/all';
  Logger logger = Logger();
  // http post request
  static Future<List<Booking>> getAllScoroBookings() async {
    http.Response response = await http.get(
        Uri.https(baseApiUrl, scoroBookingsEndpointParam),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> responseMap = jsonDecode(response.body);

    if (responseMap["status"] == ApiResponseStatus.ok) {
      if (responseMap['data'] != null) {
        List<Booking> bookingList = [];
        responseMap["data"].forEach((v) {
          bookingList.add(Booking.fromJson(v));
        });
        return bookingList;
      }
    }
    return [];
  }

  static Future<List<Booking>> getAllPrintedBookings() async {
    http.Response response = await http.get(
        Uri.https(baseApiUrl, allPrintedBookingsEndpointParam),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    if (responseMap["status"] == ApiResponseStatus.ok) {
      if (responseMap['data'] != null) {
        List<Booking> bookingList = [];
        responseMap["data"].forEach((v) {
          bookingList.add(Booking.fromJson(v));
        });
        return bookingList;
      }
    }
    return [];
  }
}
