

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  String? get getUserId => _firebaseAuth.currentUser?.uid;


}