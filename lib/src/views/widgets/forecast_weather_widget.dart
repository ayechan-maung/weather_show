import 'package:flutter/material.dart';
import 'package:weather_show/app_consts.dart';

import '../../model/forecast_weather_data_model.dart';

class ForecastWeatherWidget extends StatelessWidget {
  final Forecast forecastWeather;

  const ForecastWeatherWidget(this.forecastWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecastWeather.forecastday![0].hour!.length,
            itemBuilder: (context, index) {
              final item = forecastWeather.forecastday![0].hour![index];
              return hourForecast(item);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: forecastWeather.forecastday!.length,
            itemBuilder: (context, index) {
              final day = forecastWeather.forecastday![index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(dayFormat(day.date ?? "")),
                    const Spacer(),
                    Text("${day.day!.maxtempC!.round()} / ${day.day!.mintempC!.round()}"),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget dayForecast(Day day) {
    return Container();
  }

  Widget hourForecast(Hour hour) {
    final sty = TextStyle(fontWeight: FontWeight.bold, fontSize: 17);
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            twelveHrFormat(hour.time ?? ""),
            style: sty,
          ),
          Text(
            "${hour.tempC!.round()} °",
            style: sty,
          )
        ],
      ),
    );
  }
}
