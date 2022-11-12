import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';
import 'package:vthacks2022/ui/home.dart';
import 'package:vthacks2022/ui/login.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenticationService>(context);

    provider.verifyAuthStatus(); // Updates status accordingly

    switch (provider.status) {
      case AuthenticationStatus.uninitialized:
        return LoginPage();
      case AuthenticationStatus.unauthenticated:
        return LoginPage();
      case AuthenticationStatus.authenticating:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AuthenticationStatus.authenticated:
        return const Scaffold(
          body: Center(
            child: Home(),
          ),
        );
    }
  }
}
