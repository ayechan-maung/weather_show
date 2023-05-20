import 'package:intl/intl.dart';

const API_KEY = "cb014cd6e26142039cb90825231905";

const BASE_URL = "http://api.weatherapi.com/v1/";


String twelveHrFormat(String date) {
  final twelveHr = DateFormat("hh aa").format(DateTime.parse(date));

  return twelveHr;
}

String dayFormat(String date) {
  final dayFormat = DateFormat.E().format(DateTime.parse(date));

  return dayFormat;
}