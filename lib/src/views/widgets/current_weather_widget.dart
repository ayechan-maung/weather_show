import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/app_consts.dart';
import 'package:weather_show/src/bloc/weather_cubit.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';
import 'package:weather_show/src/utilities/extensions.dart';
import 'package:weather_show/src/views/widgets/search.dart';

import 'hour_forecast.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final ForecastWeatherDataModel currentWeather;

  CurrentWeatherWidget(this.currentWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final size = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (_, __) {
        return [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            actions: [
              // AnimSearchBar(
              //     width: size.width - 70,
              //     textController: textController,
              //     onSuffixTap: () {},
              //     onSubmitted: (s) {},
              //     color: Colors.transparent,),
              IconButton(onPressed: (){
                showSearch(context: context, delegate: CustomSearchDelegate()).then((value) {
                  print("Search Value $value");
                  if(value != null || value.isNotEmpty) {
                    context.read<WeatherCubit>().fetchForecastWeather(value);
                  }
                });
              }, icon: Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            ],
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              background: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          currentWeather.location?.name ?? "",
                          style: context.getTextTheme.headlineLarge,
                        ),
                      ),
                      Text(
                        currentWeather.current!.tempC!.toStringAsFixed(0) + " °C",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 45),
                      ),
                      Text(
                          "(${currentWeather.location!.region}, ${currentWeather.location!.country})"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        "assets/${currentWeather.current!.isDay == 1 ? 'day' : 'night'}/${getIcon(currentWeather.current!.condition!.code!)}.png",
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ];
      },
      body: ListView(
        children: [
          Text(currentWeather.current!.condition!.text ?? "",
              style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _itemRow("Feels Like",
                    currentWeather.current!.feelslikeC!.round().toStringAsFixed(0) + " °"),
                _itemRow("Wind", currentWeather.current!.windKph!.round().toStringAsFixed(0)),
                _itemRow("Visibility", currentWeather.current!.visKm.toString()),
                _itemRow("Wind", currentWeather.current!.windKph!.round().toStringAsFixed(0)),
                _itemRow("Humidity", "${currentWeather.current!.humidity} %"),
                _itemRow("Pressure", currentWeather.current!.pressureMb.toString()),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Row(
              children: [
                Icon(Icons.calendar_view_week),
                Text(
                  "Three Days Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentWeather.forecast!.forecastday!.length,
              itemBuilder: (context, index) {
                final day = currentWeather.forecast!.forecastday![index];

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        dayFormat(day.date ?? ""),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        "assets/day/${getIcon(day.day!.condition!.code!)}.png",
                        width: 45,
                        height: 45,
                      ),
                      const Spacer(),
                      Text(
                        "${day.day!.mintempC!.round()} / ${day.day!.maxtempC!.round()}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(String label, String value) {
    final sty = const TextStyle(fontSize: 18);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            label,
            style: sty,
          ),
          Text(
            value,
            style: sty,
          )
        ],
      ),
    );
  }
}
