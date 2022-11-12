import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';
import 'package:vthacks2022/ui/home.dart';
import 'package:vthacks2022/ui/login.dart';
import 'package:vthacks2022/ui/intro.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenticationService>(context);

    if (provider.status == AuthenticationStatus.authenticated) {
      return Home();
    }
    // else if (provider.status == AuthenticationStatus.unauthenticated ||
    //     provider.status == AuthenticationStatus.authenticating ||
    //     provider.status == AuthenticationStatus.uninitialized) {
    else {
      return LoginPage();
    }
    /*else {
      return LoginPage(); // TODO: Put this back to the intro screen
    }*/
  }
}
