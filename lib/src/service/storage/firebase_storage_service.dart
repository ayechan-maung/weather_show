

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:weather_show/main.dart';
import 'package:weather_show/src/service/auth_service.dart';

class FirebaseStorageService {
  final _firebaseStorage = FirebaseFirestore.instance;

  Future<List<String?>> getUsersToken() async {
    final result = await _firebaseStorage.collection("users").get();
    final userId = authService.getUserId;
    List<String?> tokens = [];
    for (var doc in result.docs) {
      if(doc.data()['userId'] != userId) {
        tokens.add(doc.data()['token']);
      }
    }
    return tokens;
  }

  Future<String?> getDeviceId() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    return deviceId;
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in
    String? userId = authService.getUserId;
    final deviceId = await getDeviceId();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(deviceId)
        .set({'token': token, 'userId': userId})
        .then((value) => debugPrint("Saved and updated "))
        .catchError((error) => debugPrint("Failed to merge data: $error"));
  }
}