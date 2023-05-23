
import 'package:http/http.dart' as http;
import 'package:weather_show/app_consts.dart';

class PushMessage {

  Future<void> sendPushMessage(String body) async {
    try {
      final res = await http.post(
        Uri.parse(SEND_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': SERVER_KEY,
        },
        body: body,
      );
      print('${res.body} FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}