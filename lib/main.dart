import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/bloc/index_cubit.dart';
import 'package:weather_show/src/bloc/search_weather_cubit.dart';
import 'package:weather_show/src/repository/search_weather_repo.dart';
import 'package:weather_show/src/service/http/dio_http_service.dart';

import 'src/bloc/weather_cubit.dart';
import 'src/repository/http_weather_repository.dart';
import 'src/views/weather_app_view.dart';

void main() {
  final httpService = DioHttpService();
  runApp(
    MyWeatherApp(
      weatherRepository: HttpWeatherRepository(httpService),
      searchRepository: SearchWeatherRepository(httpService),
    ),
  );
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key, required this.weatherRepository, required this.searchRepository});

  final HttpWeatherRepository weatherRepository;
  final SearchWeatherRepository searchRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WeatherCubit(weatherRepository)),
        BlocProvider(create: (context) => SearchWeatherCubit(searchRepository)),
        BlocProvider(create: (context) => IndexCubit()),
      ],
      child: MaterialApp(
        title: 'Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WeatherApp(),
      ),
    );
  }
}

