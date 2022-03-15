import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:spense_app/base/exception/app_exception.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart' as GETX;

class ApiUtil {
  static Dio? client;

  static Future<Map<String, String>> _getOtherCommonHeaders() async {
    HashMap<String, String> headers = HashMap();

    final authToken = PreferenceUtil.on.read<String?>(
      keyAuthToken,
      defaultValue: null,
    );

    if (TextUtil.isNotEmpty(authToken)) {
      headers[HttpHeaders.authorizationHeader] = authToken!;
    }

    return headers;
  }

  static void _handleException(dynamic e) {
    if ((e != null) && (e is DioError) && (e.message.trim().isNotEmpty)) {
      if (e.error is SocketException) {
        throw AppException('no_internet_connection'.tr, e);
      } else {
        throw AppException(e.message, e);
      }
    } else {
      throw e;
    }
  }

  static Future<Response> getRequest({
    required String endPoint,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options = options.copyWith(
        headers: await _getOtherCommonHeaders(),
      );
    }

    try {
      response = await client!.get(
        endPoint,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options = options.copyWith(
        headers: await _getOtherCommonHeaders(),
      );
    }

    try {
      response = await client!.post(
        endPoint,
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> postFormUrlEncodedRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options(contentType: Headers.formUrlEncodedContentType);

    if (shouldGetOtherHeaders) {
      options = options.copyWith(
        headers: await _getOtherCommonHeaders(),
      );
    }

    try {
      response = await client!.post(
        endPoint,
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options = options.copyWith(
        headers: await _getOtherCommonHeaders(),
      );
    }

    try {
      response = await client!.put(
        endPoint,
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> multiPartPostRequest({
    required String endPoint,
    required Map<String, dynamic> data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options = options.copyWith(
        headers: await _getOtherCommonHeaders(),
      );
    }

    try {
      response = await client!.post(
        endPoint,
        data: FormData.fromMap(data),
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static String appendPathIntoPostfix(String postFix, String? value) {
    if (value != null && value.trim().isNotEmpty && postFix.trim().isNotEmpty) {
      postFix += ("/" + value);
    }

    return postFix;
  }

  static String appendParamIntoPostfix(
    String postFix,
    String key,
    String? value,
  ) {
    if (value != null) {
      if (postFix.isEmpty) {
        postFix += "?";
      } else {
        postFix += "&";
      }

      postFix += (key + "=" + value);
    }

    return postFix;
  }

  static Map<String, dynamic> appendParamIntoData(
    Map<String, dynamic> data,
    String key,
    dynamic value,
  ) {
    if (value != null) {
      data[key] = value;
    }

    return data;
  }
}
