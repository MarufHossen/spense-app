import 'package:dio/dio.dart';

class AppException implements Exception {
  final String? _message;
  final DioError? error;

  AppException([
    this._message,
    this.error,
  ]);

  String toString() {
    return (_message != null && _message!.trim().isNotEmpty) ? "$_message" : "";
  }
}
