
import 'package:http/http.dart' as http;

class PushMessage {

  Future<void> sendPushMessage(String body) async {
    try {
      final res = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "key=AAAAybN_4vM:APA91bErSLZVSUphxZBreSSCZTm4iKGCYJu3n0Zl6UY5OrIUqNO4EnDstpWV1TaEBgxmKXYVoi-vegMDRG58n5rTAE63LJ51_8k5Mt3aWjUu4iQ8gJDAPlNPnYCKgeDT85kp3PPRldmd",
        },
        body: body,
      );
      print('${res.body} FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}