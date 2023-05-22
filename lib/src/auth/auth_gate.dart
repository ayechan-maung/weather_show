import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_show/src/views/widgets/card_item.dart';

import '../views/admin_view.dart';
import '../views/weather_app_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView(
                children: [
                  CardItem(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.white.withOpacity(0.7),
                    child: FirebaseUIActions(
                        actions: [
                          AuthStateChangeAction<SignedIn>((context, state) {
                            if(state.user != null) {
                              setupToken();
                            }
                            if (!state.user!.emailVerified) {
                              // Navigator.pushNamed(context, '/verify-email');
                            } else {
                              // Navigator.pushReplacementNamed(context, '/profile');
                            }
                          }),
                        ],
                        child: Center(
                          child: LoginView(
                            action: AuthAction.signIn,
                            showAuthActionSwitch: false,
                            providers: FirebaseUIAuth.providersFor(FirebaseAuth.instance.app),
                            subtitleBuilder: (context, action) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Welcome to Weather Show admin, please sign in!')
                              );
                            },
                            footerBuilder: (context, action) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  'By signing in, you agree to our terms and conditions.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                ],
              );
            }

            return AdminView();
          },
        ),
      ),
    );
  }
}
