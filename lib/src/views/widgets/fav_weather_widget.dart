import 'package:flutter/material.dart';
import 'package:weather_show/src/service/storage/fav_city_storage.dart';
import 'package:weather_show/src/views/widgets/card_item.dart';

import '../../model/forecast_weather_data_model.dart';

class FavoriteWeatherWidget extends StatelessWidget {
  const FavoriteWeatherWidget();
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: FavCityStorage.instance.getAllWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ForecastWeather> cities = snapshot.requireData;
            if (cities.isEmpty) {
              return const Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🏙️', style: TextStyle(fontSize: 64)),
                  Text('Your favorite cites are empty.')
                ],
              ));
            }
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return FavCityWidget(location: cities[index].location,current: cities[index].current);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class FavCityWidget extends StatelessWidget {
  final Location? location;
  final Current? current;

  const FavCityWidget({Key? key, this.location, this.current}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const fontSty = TextStyle(color: Colors.white);
    return CardItem(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8),
      color: Colors.white.withOpacity(0.4),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location?.name ?? "",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text("(${location?.region}, ${location?.country})", style: fontSty,)
            ],
          ),
          const Spacer(),
          Image.asset(
            "assets/day/${getIcon(current!.conditionCode ?? 1000)}.png",
            width: 45,
            height: 45,
          ),

          Text(
            "${current!.tempC!.round()} °C",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
