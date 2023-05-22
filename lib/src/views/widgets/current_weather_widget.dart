import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/app_consts.dart';
import 'package:weather_show/src/auth/auth_gate.dart';
import 'package:weather_show/src/bloc/weather_cubit.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';
import 'package:weather_show/src/utilities/extensions.dart';
import 'package:weather_show/src/views/widgets/card_item.dart';
import 'package:weather_show/src/views/widgets/fav_weather_widget.dart';
import 'package:weather_show/src/views/widgets/search.dart';

import '../../service/storage/fav_city_storage.dart';
import 'hour_forecast.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final ForecastWeather currentWeather;

  CurrentWeatherWidget(this.currentWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (_, __) {
        return [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearchDelegate()).then((value) {
                      // if (value != null) {
                      //   context.read<WeatherCubit>().fetchForecastWeather(value);
                      // }
                    });
                  },
                  icon: const Icon(Icons.search, color: Colors.white)),
              // PopupMenuButton<int>(
              //   onSelected: (value) {
              //     switch (value) {
              //       case 0:
              //         Navigator.of(context)
              //             .push(MaterialPageRoute(builder: (context) => const AuthGate()));
              //     }
              //   },
              //   itemBuilder: (context) {
              //     return [
              //       PopupMenuItem(
              //           value: 0,
              //           child: _popupItem(
              //               label: "Admin",
              //               trailing: const Icon(CupertinoIcons.person_alt_circle))),
              //       PopupMenuItem(
              //           value: 1,
              //           child: _popupItem(
              //               label: "Celsius",
              //               trailing: const Padding(
              //                 padding: EdgeInsets.only(right: 4.0),
              //                 child: Text(
              //                   " °C",
              //                   style: TextStyle(fontSize: 17),
              //                 ),
              //               ))),
              //       PopupMenuItem(
              //           value: 2,
              //           child: _popupItem(
              //               label: "Fahrenheit",
              //               trailing: const Padding(
              //                 padding: EdgeInsets.only(right: 4.0),
              //                 child: Text(
              //                   " °F",
              //                   style: TextStyle(fontSize: 17),
              //                 ),
              //               ))),
              //     ];
              //   },
              //   icon: const Icon(Icons.menu, color: Colors.white),
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              // )
            ],
          )
        ];
      },
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.end,
        // textBaseline: TextBaseline.alphabetic,
        children: [
          Column(
            children: [
              Text(dateFormat(currentWeather.location!.localtime!),
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
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            children: [
              Image.asset(
                "assets/${currentWeather.current!.isDay == 1 ? 'day' : 'night'}/${getIcon(currentWeather.current!.condition!.code!)}.png",
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
              Text(
                currentWeather.current!.condition!.text ?? "",
                style: const TextStyle(color: Colors.white),
              )
            ],
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
