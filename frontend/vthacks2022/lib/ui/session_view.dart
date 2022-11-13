import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/session_service.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';

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
    // SessionService sessionService = Provider.of<SessionService>(context);
    // SessionParticipantService sessionParticipantService =
    //     Provider.of<SessionParticipantService>(context);

    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextButton(
              onPressed: () {
                // sessionService.createSession();
              },
              child: Text("Create Session"),
            ),
          ),
          Container(
            child: TextButton(
              onPressed: () {
                // sessionParticipantService.createSessionParticipant();
              },
              child: Text("Join Session"),
            ),
          ),
        ],
      ),
    );
  }
}
