import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/utilities/extensions.dart';

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
            SliverAppBar(
              backgroundColor: Colors.transparent,
              actions: [
                BlocConsumer<FavDbCubit, FavDbState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () async {
                        context.read<FavDbCubit>().addFavorite(currentWeather);
                      },
                      icon: Icon(state.isFavorite != null && state.isFavorite! ? Icons.favorite: Icons.favorite_border_rounded, color: Colors.white),
                    );
                  },
                ),
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
                // Text(dateFormat(currentWeather.location!.localtime!),
                //     style: const TextStyle(color: Colors.white)),
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
                      currentWeather.current!.condition!.code!)}.png",
                  width: 130,
                  height: 130,
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
      ),
    );
  }

}