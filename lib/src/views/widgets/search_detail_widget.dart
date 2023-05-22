
import 'package:flutter/material.dart';
import 'package:weather_show/app_consts.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';
import 'package:weather_show/src/utilities/extensions.dart';
import 'package:weather_show/src/views/widgets/card_item.dart';

import '../../service/storage/fav_city_storage.dart';
import 'hour_forecast.dart';


class SearchDetailWidget extends StatelessWidget {
  final ForecastWeather currentWeather;

  SearchDetailWidget(this.currentWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () async {
                    await FavCityStorage.instance.addCityWeather(currentWeather);
                  },
                  icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
                ),
              ],
              expandedHeight: 165,
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
                            style: context.getTextTheme.headlineLarge!.copyWith(color: Colors.white),
                          ),
                        ),
                        Text(
                          currentWeather.current!.tempC!.toStringAsFixed(0) + " °C",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 45, color: Colors.white),
                        ),
                        Text(
                            "(${currentWeather.location!.region}, ${currentWeather.location!.country})",
                            style: const TextStyle(color: Colors.white)),
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
          padding: const EdgeInsets.only(top: 16),
          children: [
            // const SizedBox(
            //   height: 10,
            // ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Icon(Icons.watch_later_outlined, color: Colors.white),
                  Text(
                    "Hourly Forecast",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            CardItem(
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
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  Icon(Icons.calendar_view_week, color: Colors.white),
                  Text(
                    "Three Days Forecast",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            CardItem(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: currentWeather.forecast!.forecastday!
                    .map((day) => Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayFormat(day.date ?? ""),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(day.day!.condition!.text ?? "", style:const TextStyle(color: Colors.white),)
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        "assets/day/${getIcon(day.day!.condition!.code!)}.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __)=> const Icon(Icons.info, color: Colors.grey),
                      ),

                      Column(
                        children: [
                          Text(
                            "${day.day!.maxtempC!.round()} °",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                          Text(
                            "${day.day!.mintempC!.round()} °",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
            CardItem(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentWeather.current!.condition!.text ?? "",
                      style: const TextStyle(fontSize: 20, color: Colors.white)),
                  SizedBox(height: 12),
                  _itemRow("Feels Like",
                      currentWeather.current!.feelslikeC!.round().toStringAsFixed(0) + " °C"),
                  _itemRow(
                      "Wind", currentWeather.current!.windKph!.round().toStringAsFixed(0) + " kph"),
                  _itemRow("Visibility", currentWeather.current!.visKm.toString() + " km"),
                  _itemRow("Humidity", "${currentWeather.current!.humidity} %"),
                  _itemRow("Pressure", currentWeather.current!.pressureMb.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemRow(String label, String value) {
    final sty = const TextStyle(fontSize: 18, color: Colors.white);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _popupItem({required String label, Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 17),
        ),
        trailing ?? Container()
      ],
    );
  }
}
