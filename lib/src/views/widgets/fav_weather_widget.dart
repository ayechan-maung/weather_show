import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_show/src/bloc/db_bloc/fav_db_cubit.dart';
import 'package:weather_show/src/service/storage/fav_city_storage.dart';
import 'package:weather_show/src/views/widgets/card_item.dart';

import '../../model/forecast_weather_data_model.dart';
import '../fav_city_detail_view.dart';

class FavoriteWeatherWidget extends HookWidget {
  const FavoriteWeatherWidget();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<FavDbCubit>().getAllCities();
      return () {};
    }, const []);

    return BlocConsumer<FavDbCubit, FavDbState>(listener: (context, state) {
      // context.watch<FavDbCubit>().getAllCities();
    }, builder: (context, state) {
      switch (state.status) {
        case FavDBStatus.initial:
          return Container();
        case FavDBStatus.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case FavDBStatus.success:
          List<ForecastWeather> cities = state.weathers ?? [];
          if (cities.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🏙️', style: TextStyle(fontSize: 64)),
                  Text('Your favorite cites are empty.')
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final item = cities[index];
              return Dismissible(
                key: Key(item.location!.name!),
                onDismissed: (dir) {
                  FavCityStorage.instance.deleteWeather(item.location!.id!);
                },
                child: FavCityWidget(location: item.location, current: item.current),
              );
            },
          );
        case FavDBStatus.failure:
          return const Center(
            child: Text("Something went wrong!."),
          );
      }
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
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FavCityDetailView(id: location!.id!)));
      },
      child: CardItem(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        margin: const EdgeInsets.all(8),
        color: Colors.white.withOpacity(0.4),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location?.name ?? "",
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "(${location?.region}, ${location?.country})",
                  style: fontSty,
                )
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
      ),
    );
  }
}
