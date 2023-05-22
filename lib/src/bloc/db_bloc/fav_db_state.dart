part of 'fav_db_cubit.dart';

enum FavDBStatus{initial, loading, success, failure}

class FavDbState {
  final FavDBStatus status;
  final bool? isFavorite;
  final List<ForecastWeather>? weathers;
  FavDbState({this.status = FavDBStatus.initial, this.isFavorite, this.weathers});

  FavDbState copyWith({bool? isFavorite, FavDBStatus? status, List<ForecastWeather>? weathers}) {
    return FavDbState(status: status ?? FavDBStatus.initial, isFavorite: isFavorite, weathers: weathers);
  }
}
