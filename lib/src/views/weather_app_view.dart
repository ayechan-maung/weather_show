import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:weather_show/main.dart';
import 'package:weather_show/src/service/location_service.dart';
import 'package:weather_show/src/views/widgets/weather_initial_widget.dart';
import 'package:weather_show/src/views/widgets/weather_loading_widget.dart';

import '../bloc/weather_cubit.dart';
import '../bloc/weather_state.dart';
import '../service/messaging_service/messaging_service.dart';
import 'weather_home.dart';

Future<void> setupToken() async {
  // Get the token each time the application loads
  String? token = await messagingService.messageToken();

  // Save the initial token to the database
  await firebaseStoreService.saveTokenToDatabase(token!);

  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(firebaseStoreService.saveTokenToDatabase);
}

class WeatherApp extends HookWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    useEffect(() {
      FirebaseMessaging.onMessage.listen(messagingService.showFlutterNotification);

      setupToken();

      LocationService.shared.determinePosition().then((position) {
        context
            .read<WeatherCubit>()
            .fetchForecastWeather("${position.latitude},${position.longitude}");
      });

      return () {};
    }, const []);
    return Scaffold(
      body: BlocConsumer<WeatherCubit, WeatherState>(
          builder: (context, state) {
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherInitialWidget();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                int? isDay = state.forecastWeather!.current!.isDay;
                return Stack(
                  children: [
                    if (isDay == 0)
                      Image.asset(nightBgAssets(state.forecastWeather!.current!.condition!.text!),
                          fit: BoxFit.fill, width: size.width, height: size.height),
                    if (isDay == 1)
                      Image.asset(dayBgAssets(state.forecastWeather!.current!.condition!.text!),
                          fit: BoxFit.fill, width: size.width, height: size.height),
                    WeatherHome(forecastWeather: state.forecastWeather),
                  ],
                );
              case WeatherStatus.failure:
                return Center(
                  child: Text("Failure"),
                );
            }
          },
          listener: (context, state) {}),
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
      default:
        return "$background/partly_cloudy.jpg";
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
        return "assets/night_bg/heavy_cloudy.jpg";
      default:
        return "$background/night_clear.jpg";
    }
  }
}
