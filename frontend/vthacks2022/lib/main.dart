import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';
import 'package:vthacks2022/core/services/session_host_service.dart';
import 'package:vthacks2022/ui/entry_point.dart';
import 'package:vthacks2022/ui/explore.dart';
import 'package:vthacks2022/ui/session/session_view.dart';
import 'dart:async';
import 'core/services/media_service.dart';
import 'core/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // things that go in here can be accessed by the rest of the app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MediaService()),
        ChangeNotifierProvider(create: (_) => AuthenticationService()),
        ChangeNotifierProvider(create: (_) => SessionHostService()),
        ChangeNotifierProvider(create: (_) => SessionParticipantService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    authService.setupAuth();

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
      home: const EntryPoint(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
