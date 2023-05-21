

import 'package:flutter/material.dart';
import 'package:weather_show/src/service/http/dio_http_service.dart';

import '../../app_consts.dart';
import '../model/current_weather_data_model.dart';
import '../model/forecast_weather_data_model.dart';
import 'weather_repository.dart';

class HttpWeatherRepository extends WeatherRepository {
  HttpWeatherRepository(this.httpService);
  final DioHttpService httpService;

  @override
  Future<CurrentWeatherDataModel> getCurrentWeather(
      {required String endPoint, required String? city}) async {
    final response = await httpService
        .get(endPoint, queryParameters: {'q': city, 'key': API_KEY});
    return CurrentWeatherDataModel.fromJson(response);
  }

  @override
  Future<ForecastWeather> getForecastWeather(String? city) async{
    final response = await httpService
        .get("forecast.json", queryParameters: {'q': city, 'key': API_KEY, 'days': 3});
    debugPrint("Response:: $response");
    return ForecastWeather.fromJson(response);
  }
}
