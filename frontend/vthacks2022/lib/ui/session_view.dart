import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/session_host_service.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';

import '../core/models/session_host.dart';

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  @override
  Widget build(BuildContext context) {
    // Two buttons "Create Session and Join Session" that each generate a form
    // that allows the user to enter a session code and then either create or join a session
    // based on the button they pressed
    SessionHostService sessionService =
        Provider.of<SessionHostService>(context);
    SessionParticipantService sessionParticipantService =
        Provider.of<SessionParticipantService>(context);

    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextButton(
              onPressed: () {
                var name = "Placeholder Session Name";
                var code = Random().nextInt(900000) + 100000;
                sessionService.createSession(name, code);
              },
              child: const Text("Create Session"),
            ),
          ),
          Container(
            child: TextButton(
              onPressed: () {
                var code = 1;

                // TODO:
                // sessionParticipantService.createSessionParticipant();
              },
              child: const Text("Join Session"),
            ),
          ),
        ],
      ),
    );
  }
}
