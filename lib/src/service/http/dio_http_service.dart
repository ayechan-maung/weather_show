import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import '../../../app_consts.dart';
import 'http_service.dart';

class DioHttpService implements HttpService {
  /// Creates new instance of [DioHttpService]
  DioHttpService(
      // this.storageService,
      {
    Dio? dioOverride,
    bool enableCaching = true,
  }) {
    dio = dioOverride ?? Dio(baseOptions);
  }

  /// The Dio Http client
  late final Dio dio;

  /// The Dio base options
  BaseOptions get baseOptions => BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      );

  @override
  String get baseUrl => BASE_URL;

  @override
  Map<String, String> headers = {
    'accept': 'application/json',
    'content-type': 'application/json'
  };

  @override
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool forceRefresh = false,
    String? customBaseUrl,
  }) async {
    // dio.options.extra[Configs.dioCacheForceRefreshKey] = forceRefresh;

    final Response<dynamic> response = await dio.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: queryParameters,
    );
    if (response.data == null || response.statusCode != 200) {
      // throw HttpException(
      //   title: 'Http Error!',
      //   statusCode: response.statusCode,
      //   message: response.statusMessage,
      // );
      throw Exception('Throwing Error');
    }

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final Response<dynamic> response = await dio.post<Map<String, dynamic>>(
      endpoint,
      queryParameters: queryParameters,
    );

    if (response.data == null || response.statusCode != 200) {
      // throw HttpException(
      //   title: 'Http Error!',
      //   statusCode: response.statusCode,
      //   message: response.statusMessage,
      // );
      throw Exception('Throwing Error');
    }

    return response.data;
  }

  @override
  Future search(String endpoint, {Map<String, dynamic>? queryParameters}) async{
    final Response<dynamic> response = await dio.get(
      endpoint,
      queryParameters: queryParameters,
    );

    debugPrint("Response $response, Status Code ${response.statusCode}");

    if (response.data == null || response.statusCode != 200) {
      // throw HttpException(
      //   title: 'Http Error!',
      //   statusCode: response.statusCode,
      //   message: response.statusMessage,
      // );
      throw Exception('Throwing Error');
    }

    return response.data;
  }
}
