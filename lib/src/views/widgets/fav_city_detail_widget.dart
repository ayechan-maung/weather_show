import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/utilities/extensions.dart';

import '../../../app_consts.dart';
import '../../bloc/db_bloc/fav_db_cubit.dart';
import '../../model/forecast_weather_data_model.dart';

class FavCityDetailWidget extends StatelessWidget {
  final ForecastWeather currentWeather;

  FavCityDetailWidget(this.currentWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite),
                ), //: Icons.favorite_border_rounded, color: Colors.white
              ],
            )
          ];
        },
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(currentWeather.location!.localtime ?? "",
                    style: const TextStyle(color: Colors.white)),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    currentWeather.location?.name ?? "",
                    style: context.getTextTheme.headlineLarge!.copyWith(color: Colors.white),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: currentWeather.current!.tempC!.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 60, color: Colors.white),
                    children: const [
                      TextSpan(
                          text: " °C", style: TextStyle(fontSize: 24, color: Colors.white)),
                    ],
                  ),
                ),
                Text(
                    "(${currentWeather.location!.region}, ${currentWeather.location!.country})",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  "assets/${currentWeather.current!.isDay == 1 ? 'day' : 'night'}/${getIcon(
                      currentWeather.current!.conditionCode ?? 1300)}.png",
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (ctx, _,__)=> Container(),
                ),
                Text(
                  currentWeather.current!.conditionText ?? "",
                  style: const TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}