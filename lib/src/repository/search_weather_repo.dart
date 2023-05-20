import 'package:weather_show/app_consts.dart';
import 'package:weather_show/src/model/search_result.dart';
import 'package:weather_show/src/service/http/dio_http_service.dart';

class SearchWeatherRepository {
  final DioHttpService httpService;

  SearchWeatherRepository(this.httpService);

  Future<List<SearchResults>> searchWeather(String? query) async {
    final response =
        await httpService.search("search.json", queryParameters: {"key": API_KEY, "q": query});

    print("Result:: $response");
    return List<SearchResults>.from(
      (response as List<dynamic>).map<SearchResults>((result) => SearchResults.fromJson(result)),
    );
  }
}
