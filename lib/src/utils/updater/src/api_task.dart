import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class APITask {
  static final APITask _instance = APITask._internal();
  late Dio _dio;

  APITask._internal() {
    _dio = Dio();
  }

  factory APITask() => _instance;

  Future<Response<T>> get<T>(String url) async {
    return await _dio.get<T>(url);
  }

  Future<Response<T>> post<T>(String url, Map<String, dynamic> data) async {
    return await _dio.post<T>(url, data: data);
  }

  Future<Response> download(String url, fileName,
      {CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      Options? options,
      bool deleteOnError = false}) async {
    return await _dio.download(
      url,
      fileName,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
      deleteOnError: deleteOnError,
    );
  }

  Future<Response<T>> head<T>(String url) async {
    return await _dio.head<T>(url);
  }

  @visibleForTesting
  void injectDioForTesting(Dio dio) {
    _dio = dio;
  }
}
