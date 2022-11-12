import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vthacks2022/ui/entry_point.dart';
import 'package:vthacks2022/ui/home.dart';
import 'package:vthacks2022/ui/media/media_item.dart';
import 'dart:async';
import 'core/models/media.dart';
import 'core/services/media_service.dart';
import 'core/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  bool isLoggedIn = email != null;

  runApp(
    // things that go in here can be accessed by the rest of the app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MediaService()),
        ChangeNotifierProvider(create: (_) => AuthenticationService()),
      ],
      child: MyApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.isLoggedIn, Key? key}) : super(key: key);

  final bool isLoggedIn;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CINEMATCH',
      // this is the theme => can edit this for colors
      // theme: ThemeData.from(colorScheme: ColorScheme.highContrastDark(), primary: ),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal,
          // onPrimary: Colors.black,
          secondaryHeaderColor: Colors.teal[200],

          // onSecondary: Colors.black,
          // error: const Color(0xff9b374d),
          // onError: Colors.black,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black
          // onBackground: Colors.black,
          // surface: const Color(0xff121212),
          // onSurface: Colors.white,
          ),
      // ),

      // theme: ThemeData.(colorScheme: ColorScheme.fromSwatch().copyWith(
      //     primarySwatch: Colors.blue,
      //   // Color? primaryColorDark,
      //   // Color? accentColor,
      //   // Color? cardColor,
      //   // Color? backgroundColor,
      //   // Color? errorColor
      //   // Brightness brightness = Brightness.light,
      // )),
      home: const EntryPoint(
        isLoggedIn: isLoggedIn,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
