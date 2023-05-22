
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';

import '../../repository/favorite_db_repository.dart';

part 'fav_db_state.dart';

class FavDbCubit extends Cubit<FavDbState> {
  final FavoriteDBRepository dbRepository;
  FavDbCubit(this.dbRepository): super(FavDbState());

  Future<bool> addFavorite(ForecastWeather add) async {
    final filter = await dbRepository.getAllCities();
    debugPrint("ID:: ${add.location!.id}");
    if(!filter.contains(add)){
      await dbRepository.addFavorite(add);
      emit(state.copyWith(isFavorite: true));
      return true;

    }else{
      await dbRepository.deleteFavorite(add.location!.id!);
      emit(state.copyWith(isFavorite: false));
      return false;
    }
  }

  Future<bool> checkValue(ForecastWeather add) async {
    final filter = await dbRepository.getAllCities();
    print("Boolean:: ${filter.contains(add)}");
    emit(state.copyWith(isFavorite: filter.contains(add)));
    return filter.contains(add);
  }

  Future<void> getAllCities() async {
    emit(state.copyWith(status: FavDBStatus.loading));
    final results = await dbRepository.getAllCities();
    emit(state.copyWith(status: FavDBStatus.success, weathers: results));
  }

  Future<void> getCityDetail(int id) async {
    emit(state.copyWith(status: FavDBStatus.loading));
    final result = await dbRepository.getCityDetail(id);
    emit(state.copyWith(status: FavDBStatus.success, weather: result));
  }
}
