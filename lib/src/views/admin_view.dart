import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

class AdminView extends HookWidget {
   AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleController = useTextEditingController();
    var messageController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileScreen(
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: titleController,
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: messageController,
          ),
          const SizedBox(
            height: 12,
          ),
          TextButton(onPressed: sendPushMessage, child: const Text("Send Notifications"))
        ],
      ),
    );
  }

  Future<void> sendPushMessage() async {
    final _token = await FirebaseMessaging.instance.getToken();
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('${res.body} FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  int _messageCount = 0;

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }
}
