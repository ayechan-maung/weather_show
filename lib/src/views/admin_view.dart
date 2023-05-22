import 'dart:convert';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_show/main.dart';

class AdminView extends HookWidget {
  AdminView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var titleController = useTextEditingController();
    var messageController = useTextEditingController();
    var isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(
                          actions: [
                            SignedOutAction((context) {
                              Navigator.of(context).pop();
                            }),
                            AuthStateChangeAction((context, state) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Provider successfully linked!"),
                                ),
                              );
                            }),
                          ],
                        )));
              },
              icon: const Icon(CupertinoIcons.profile_circled))
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  validator: (text){
                    if(text!.isEmpty) {
                      return 'Title field is required';
                    }
                    return null;
                  },
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text('Title')
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (text){
                    if(text!.isEmpty) {
                      return 'Body field is required';
                    }
                    return null;
                  },
                  controller: messageController,
                  decoration: const InputDecoration(
                      label: Text('Body')
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                OutlinedButton(
                  onPressed: () async {
                    if(!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      isLoading.value = true;
                      List<String?> tokens = await firebaseStoreService.getUsersToken();
                      Map<String, dynamic> sendBody = {};
                      Map<String, dynamic> notification = {};
                      // notification
                      notification['title'] = titleController.text;
                      notification['body'] = messageController.text;
                      // body
                      sendBody['registration_ids'] = tokens;
                      sendBody['direct_boot_ok'] = true;
                      sendBody['notification'] = notification;
                      debugPrint("body $sendBody");
                      pushMessage.sendPushMessage(jsonEncode(sendBody));
                      isLoading.value = false;
                    }
                  },
                  child: const Text("Send Notifications"),
                )
              ],
            ),
          ),
          if(isLoading.value)
          const Align(
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
        ],
      ),
    );
  }
}
//   Future<void> sendPushMessage() async {
//     // final _token = await FirebaseMessaging.instance.getToken();
//     // if (_token == null) {
//     //   print('Unable to send FCM message, no token exists.');
//     //   return;
//     // }
//     List<String?> tokens = await firebaseStoreService.getUsersToken();
//
//     try {
//       final res = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization':
//               "key=AAAAybN_4vM:APA91bErSLZVSUphxZBreSSCZTm4iKGCYJu3n0Zl6UY5OrIUqNO4EnDstpWV1TaEBgxmKXYVoi-vegMDRG58n5rTAE63LJ51_8k5Mt3aWjUu4iQ8gJDAPlNPnYCKgeDT85kp3PPRldmd",
//         },
//         body: constructFCMPayload(tokens),
//       );
//       print('${res.body} FCM request for device sent!');
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   int _messageCount = 0;
//
//   /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
//   String constructFCMPayload(List<String?> tokens) {
//     //String? token
//     _messageCount++;
//     return jsonEncode({
//       // 'to': regId,
//       'registration_ids': tokens,
//       'data': {
//         'via': 'FlutterFire Cloud Messaging!!!',
//         'count': _messageCount.toString(),
//       },
//       'notification': {
//         'title': 'Hello FlutterFire!',
//         'body': 'This notification (#$_messageCount) was created via FCM!',
//       },
//       "direct_boot_ok": true
//     });
//   }
// }
