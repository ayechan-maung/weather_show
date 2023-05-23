

import 'package:flutter/cupertino.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';

import '../service/storage/fav_city_storage.dart';

class FavoriteDBRepository {
  // final FavCityStorage favCityStorage;
  //
  // FavoriteDBRepository(this.favCityStorage);

  Future<List<ForecastWeather>> getAllCities() async {
    final allCityWeather = await FavCityStorage.instance.getAllWeather();
    return allCityWeather;
  }

  Future<ForecastWeather> addFavorite(ForecastWeather city) async {
    final cityWeather = await FavCityStorage.instance.addCityWeather(city);
    return cityWeather;
  }

  Future<int> deleteFavorite(int id) async {
    final delete = await FavCityStorage.instance.deleteWeather(id);
    return delete;
  }

  Future<int> updateCityWeather(Location id) async {
    final updated = await FavCityStorage.instance.updateCityWeather(id);
    return updated;
  }

  Future<ForecastWeather> getCityDetail(int id) async {
    final detail = await FavCityStorage.instance.getCityWeather(id);
    debugPrint("Detail in Repo:: ${detail.location!.id}");
    return detail;
  }
}