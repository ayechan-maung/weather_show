import 'package:flutter/material.dart';

import '../../../app_consts.dart';
import '../../model/forecast_weather_data_model.dart';

class HourForecast extends StatelessWidget {
  final Hour hour;
  const HourForecast(this.hour, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Image.asset("assets/${hour.isDay == 1? 'day': 'night'}/${getIcon(hour.condition!.code!)}.png",width: 35,height: 35,),
          Text(
            "${hour.tempC!.round()} °",
            style: sty,
          )
        ],
      ),
    );
  }
}
