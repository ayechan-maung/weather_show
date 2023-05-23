import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_show/src/bloc/db_bloc/fav_db_cubit.dart';
import 'package:weather_show/src/views/widgets/search_detail_widget.dart';

import '../bloc/search_detail_bloc/search_detail_cubit.dart';
import '../bloc/search_detail_bloc/search_detail_state.dart';
import '../bloc/weather_bloc/weather_cubit.dart';
import '../bloc/weather_bloc/weather_state.dart';
import 'widgets/weather_fail_widget.dart';
import 'widgets/weather_initial_widget.dart';
import 'widgets/weather_loading_widget.dart';

class SearchDetailView extends HookWidget {
  final String queryCity;

  const SearchDetailView({required this.queryCity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var location = useState('');
    useEffect(() {
      context.read<SearchDetailCubit>().getWeatherDetail(queryCity);

      return () {};
    }, const []);
    return Scaffold(
      body: BlocConsumer<SearchDetailCubit, SearchDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchDetailStatus.initial:
                return const WeatherInitialWidget();
              case SearchDetailStatus.loading:
                return const WeatherLoading();
              case SearchDetailStatus.success:
                int? isDay = state.forecastWeather!.current!.isDay;
                return Stack(
                  children: [
                    if (isDay == 0)
                      Image.asset(nightBgAssets(state.forecastWeather!.current!.condition!.text!),
                          fit: BoxFit.fill,
                          width: size.width,
                          height: size.height,
                          errorBuilder: (_, __, ___) => Container()),
                    if (isDay == 1)
                      Image.asset(dayBgAssets(state.forecastWeather!.current!.condition!.text!),
                          fit: BoxFit.fill,
                          width: size.width,
                          height: size.height,
                          errorBuilder: (_, __, ___) => Container()),
                    SearchDetailWidget(state.forecastWeather!),
                  ],
                );
              case SearchDetailStatus.failure:
                return WeatherFailWidget(tryAgain: () {
                  context.read<SearchDetailCubit>().getWeatherDetail(location.value);
                });
            }
          },
          listener: (context, state) {
            print("Status:: ${state.status}");
            context.read<FavDbCubit>().checkValue(state.forecastWeather!);
          }),
    );
  }

  String dayBgAssets(String condition) {
    const background = "assets/background";
    switch (condition.toLowerCase()) {
      case "sunny":
        return "$background/sunny.jpg";
      case "overcast":
        return "$background/overcast.jpg";
      case "sunny_cloudy":
        return "$background/sunny_cloudy.jpg";
      case "cloudy":
        return "assets/night_bg/heavy_cloudy.jpg";
      case "partly cloudy":
        return "$background/sunny_cloudy.jpg";
      default:
        return "$background/cloudy.jpg";
    }
  }

  String nightBgAssets(String condition) {
    const background = "assets/night_bg";
    switch (condition.toLowerCase()) {
      case "overcast":
        return "assets/background/overcast.jpg";
      case "sunny_cloudy":
        return "$background/sunny_cloudy.jpg";
      case "cloudy":
        return "$background/night_cloudy.jpg";
      case "partly cloudy":
        return "$background/night_cloudy.jpg";
      default:
        return "$background/night_clear.jpg";
    }
  }
}
