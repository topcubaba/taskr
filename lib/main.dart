// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:taskr/services/auth.dart';
import 'package:taskr/utils/consts.dart';
import 'package:taskr/utils/utils.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        home: SplashScreen.navigate(
          backgroundColor: AppColors.primary,
          name: 'assets/splash.riv',
          until: () => Future.delayed(Duration(seconds: 3)),
          startAnimation: 'Timeline 1',
          next: (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                } else if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return AuthPage();
                }
              }),
        ));
  }
}
