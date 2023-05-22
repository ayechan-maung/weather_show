import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
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
    // if (enableCaching) {
      dio.interceptors.add(DioCacheInterceptor(options: options));
    // }
  }
  final options = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),

    // All subsequent fields are optional.

    // Default.
    policy: CachePolicy.request,
    // Returns a cached response on error but for statuses 401 & 403.
    // Also allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to [null].
    hitCacheOnErrorExcept: [401, 403],
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to [null].
    maxStale: const Duration(days: 7),
    // Default. Allows 3 cache sets and ease cleanup.
    priority: CachePriority.normal,
    // Default. Body and headers encryption with your own algorithm.
    cipher: null,
    // Default. Key builder to retrieve requests.
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended when [true].
    allowPostMethod: false,
  );
  /// Storage service used for caching http responses

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
