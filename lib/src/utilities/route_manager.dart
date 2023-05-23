

import 'package:flutter/material.dart';
import 'package:weather_show/src/views/fav_city_detail_view.dart';
import 'package:weather_show/src/views/weather_app_view.dart';

class RouteManger {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const WeatherApp());
      case '/fav-detail':
        final id = settings.arguments as int?;
        return MaterialPageRoute(builder: (context) => FavCityDetailView(id: id!));
      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}