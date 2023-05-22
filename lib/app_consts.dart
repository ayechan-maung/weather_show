import 'package:intl/intl.dart';

const API_KEY = "cb014cd6e26142039cb90825231905";

const BASE_URL = "http://api.weatherapi.com/v1/";

const SEND_URL = "https://fcm.googleapis.com/fcm/send";

const SERVER_KEY = "key=AAAAybN_4vM:APA91bErSLZVSUphxZBreSSCZTm4iKGCYJu3n0Zl6UY5OrIUqNO4EnDstpWV1TaEBgxmKXYVoi-vegMDRG58n5rTAE63LJ51_8k5Mt3aWjUu4iQ8gJDAPlNPnYCKgeDT85kp3PPRldmd";


String twelveHrFormat(String date) {
  final twelveHr = DateFormat("hh aa").format(DateTime.parse(date));

  return twelveHr;
}

String dayFormat(String date) {
  final dayFormat = DateFormat.E().format(DateTime.parse(date));

  return dayFormat;
}

String dateFormat(String date) {
  final dateFormat = DateFormat.E().add_MMMMd().format(DateTime.parse(date));

  return dateFormat;
}