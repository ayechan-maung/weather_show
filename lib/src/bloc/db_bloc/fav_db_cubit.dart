
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';

import '../../repository/favorite_db_repository.dart';

part 'fav_db_state.dart';

class FavDbCubit extends Cubit<FavDbState> {
  final FavoriteDBRepository dbRepository;
  FavDbCubit(this.dbRepository): super(FavDbState());

  Future<void> addFavorite(ForecastWeather add) async {
    final filter = await dbRepository.getAllCities();
    debugPrint("ID:: ${add.location!.id}");
    int? locationId = add.location!.id;
    if(!filter.contains(add)){
      add.location?.isFavorite = 1;
      await dbRepository.addFavorite(add);
      locationId = add.location?.id;
      debugPrint("Added id $locationId");
      emit(state.copyWith(isFavorite: true));
    }else{
      await dbRepository.updateCityWeather(add.location!);
      // emit(state.copyWith(isFavorite: false));
    }
  }

  Future<bool> checkValue(ForecastWeather add) async {
    final filter = await dbRepository.getAllCities();
    print("Boolean:: ${filter.contains(add)}");
    emit(state.copyWith(isFavorite: filter.contains(add)));
    return filter.contains(add);
  }

  Future<void> getCityDetail(int id) async {
    emit(state.copyWith(detailStatus: FavDetailStatus.loading));
    final result = await dbRepository.getCityDetail(id);
    emit(state.copyWith(detailStatus: FavDetailStatus.success, weather: result));

  }

  // @override
  // Future<void> close() {
  //   return super.close();
  // }
}
