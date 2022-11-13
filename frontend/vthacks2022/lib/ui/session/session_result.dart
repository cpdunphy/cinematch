import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';

class SessionWaiting extends StatelessWidget {
  const SessionWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Show users, code, time?

    return Scaffold(
      appBar: AppBar(
        title: Text("CINEMATCH"),
      ),
      body: Container(
        child: Center(
          child: Text("Result"),
        ),
      ),
    );
  }
}
