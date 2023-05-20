import 'package:flutter/material.dart';
import 'package:weather_show/app_consts.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';
import 'package:weather_show/src/utilities/extensions.dart';

import 'hour_forecast.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final ForecastWeatherDataModel currentWeather;
  const CurrentWeatherWidget(this.currentWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            currentWeather.location?.name ?? "",
            style: context.getTextTheme.headlineLarge,
          ),
        ),
        Text("(${currentWeather.location!.region}, ${currentWeather!.location!.country})"),
        Text(
          currentWeather.current!.tempC!.toStringAsFixed(0) + " °C",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 45),
        ),
        Text(currentWeather.current!.condition!.text ?? "", style: TextStyle(fontSize: 18)),

        Card(
          elevation: 1,
          child: Column(
            children: [
              _itemRow("Feels Like", currentWeather.current!.feelslikeC!.round().toStringAsFixed(0) + " °"),
              _itemRow("Wind", currentWeather.current!.windKph!.round().toStringAsFixed(0)),
              _itemRow("Visibility", currentWeather.current!.visKm.toString()),
              _itemRow("Wind", currentWeather.current!.windKph!.round().toStringAsFixed(0)),
              _itemRow("Humidity", "${currentWeather.current!.humidity} %"),
              _itemRow("Pressure", currentWeather.current!.pressureMb.toString()),
            ],
          ),
        ),
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: currentWeather.forecast!.forecastday![0].hour!.length,
            itemBuilder: (context, index) {
              final item = currentWeather.forecast!.forecastday![0].hour![index];
              return HourForecast(item);
            },
          ),
        ),
        // Text("Three Days Forecast"),
        Expanded(
          child: ListView.builder(
            itemCount: currentWeather.forecast!.forecastday!.length,
            itemBuilder: (context, index) {
              final day = currentWeather.forecast!.forecastday![index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(dayFormat(day.date ?? "")),
                    const Spacer(),
                    Text("${day.day!.mintempC!.round()} / ${day.day!.maxtempC!.round()}"),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _itemRow(String label, String value) {
    final sty = TextStyle(fontSize: 18);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(label, style: sty,),
          Text(value, style: sty,)
        ],
      ),
    );
  }
}
