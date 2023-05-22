import 'package:floor/floor.dart';

import 'current_entity.dart';
import 'forecast_entity.dart';
import 'location_entity.dart';

@entity
class ForecastWeather {
  Location? location;
  Current? current;
  Forecast? forecast;

  ForecastWeather({this.location, this.current, this.forecast});

// ForecastWeather.fromJson(Map<String, dynamic> json) {
//   location = json['location'] != null
//       ? new Location.fromJson(json['location'])
//       : null;
//   current =
//   json['current'] != null ? new Current.fromJson(json['current']) : null;
//   forecast = json['forecast'] != null
//       ? new Forecast.fromJson(json['forecast'])
//       : null;
// }
}


// Condition.fromJson(Map<String, dynamic> json) {
//   text = json['text'];
//   icon = json['icon'];
//   code = json['code'];
// }
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['text'] = this.text;
//   data['icon'] = this.icon;
//   data['code'] = this.code;
//   return data;
// }
// }

