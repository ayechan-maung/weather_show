import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/search_result.dart';
import '../../repository/search_weather_repo.dart';

part 'search_weather_state.dart';

class SearchWeatherCubit extends Cubit<SearchWeatherState> {
  final SearchWeatherRepository searchRepository;

  SearchWeatherCubit(this.searchRepository) : super(SearchWeatherState());

  Future<void> searchWeather(String? query) async {
    emit(state.copyWith(status: SearchWeatherStatus.loading));

    try {
      final response = await searchRepository.searchWeather(query);
      print("Response:: $response");
      emit(state.copyWith(status: SearchWeatherStatus.success, searchResult: response));
    } on Exception {
      emit(state.copyWith(status: SearchWeatherStatus.failure));
    }
  }
}
