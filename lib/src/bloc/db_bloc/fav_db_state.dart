part of 'fav_db_cubit.dart';

enum FavDBStatus{initial, loading, success, failure}

class FavDbState {
  final FavDBStatus status;
  final bool? isFavorite;
  final List<ForecastWeather>? weathers;
  final ForecastWeather? weather;
  FavDbState({this.status = FavDBStatus.initial, this.isFavorite, this.weathers, this.weather});

  FavDbState copyWith({bool? isFavorite, FavDBStatus? status, List<ForecastWeather>? weathers, ForecastWeather? weather}) {
    return FavDbState(status: status ?? FavDBStatus.initial, isFavorite: isFavorite, weathers: weathers, weather: weather);
  }
}
