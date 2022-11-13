import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

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
          child: Text("Waiting for Group Participants to Finish"),
        ),
      ),
    );
  }
}
