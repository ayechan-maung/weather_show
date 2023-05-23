part of 'fav_db_cubit.dart';

enum FavDBStatus { initial, loading, success, failure }

enum FavDetailStatus { initial, loading, success, failure }

class FavDbState {
  final FavDBStatus status;
  final FavDetailStatus detailStatus;

  final bool? isFavorite;
  final List<ForecastWeather>? weathers;
  final ForecastWeather? weather;

  FavDbState(
      {this.status = FavDBStatus.initial,
      this.detailStatus = FavDetailStatus.initial,
      this.isFavorite,
      this.weathers,
      this.weather});

  FavDbState copyWith(
      {bool? isFavorite,
      FavDBStatus? status,
      FavDetailStatus? detailStatus,
      List<ForecastWeather>? weathers,
      ForecastWeather? weather}) {
    return FavDbState(
        status: status ?? FavDBStatus.initial,
        detailStatus:detailStatus ?? FavDetailStatus.initial,
        isFavorite: isFavorite,
        weathers: weathers,
        weather: weather);
  }
}
