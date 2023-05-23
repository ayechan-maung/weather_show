part of 'search_weather_cubit.dart';

enum SearchWeatherStatus { initial, loading, success, failure }

class SearchWeatherState {
  final SearchWeatherStatus status;
  final List<SearchResults>? searchResult;

  SearchWeatherState({this.status = SearchWeatherStatus.initial , this.searchResult});

  SearchWeatherState copyWith({SearchWeatherStatus? status, List<SearchResults>? searchResult}) {
    return SearchWeatherState(status: status ?? this.status, searchResult: searchResult ?? this.searchResult);
  }


}