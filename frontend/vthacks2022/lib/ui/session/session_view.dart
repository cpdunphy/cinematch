import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';
import 'package:vthacks2022/core/services/media_service.dart';
import 'package:vthacks2022/core/services/session_host_service.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:vthacks2022/ui/session/session_waiting.dart';
import 'package:vthacks2022/ui/session/swiping.dart';
import '../../../../core/models/session_host.dart';

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _SessionViewState();
}

enum SwipeState { swiping, waiting, none, result }

class _SessionViewState extends State<SessionView> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  bool isJoiningSession = true;

  SwipeState swipeState = SwipeState.none;

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("CINEMATCH"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.signOutUser();
            },
          )
        ],
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    switch (swipeState) {
      case SwipeState.swiping:
        MediaService mediaService = Provider.of<MediaService>(context);
        mediaService.getMedia();
        return Swipping();
      case SwipeState.waiting:
        return SessionWaiting();
      case SwipeState.none:
        return form(context);
      case SwipeState.result:
        return Container();
    }
  }

  Widget form(BuildContext context) {
    SessionHostService sessionHostService =
        Provider.of<SessionHostService>(context);

    SessionParticipantService sessionParticipantService =
        Provider.of<SessionParticipantService>(context);

    AuthenticationService authService =
        Provider.of<AuthenticationService>(context);
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Hosting a Session"),
                  Switch(
                    // This bool value toggles the switch.
                    value: !isJoiningSession,
                    activeColor: Color.fromARGB(255, 162, 54, 244),
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        isJoiningSession = !isJoiningSession;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white38),
            const SizedBox(
              height: 24,
            ),
            isJoiningSession
                ? joiningSession(context)
                : hostingSession(context),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  if (isJoiningSession) {
                    await sessionParticipantService.createSessionParticipant(
                        code, authService.customUser);
                    setState(() {
                      swipeState = SwipeState.swiping;
                    });
                  } else {
                    var name = _displayNameController.text;
                    sessionHostService.createSession(name);
                    await sessionParticipantService.createSessionParticipant(
                        sessionHostService.currentSession.code,
                        authService.customUser);
                    setState(() {
                      swipeState = SwipeState.swiping;
                    });
                  }
                },
                style: style,
                child: Text(
                  isJoiningSession ? "JOIN SESSION" : "HOST SESSION",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int code = 0;

  OtpFieldController otpController = OtpFieldController();

  Widget joiningSession(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Session Code"),
        ),
        OTPTextField(
          contentPadding: EdgeInsets.fromLTRB(8, 24, 8, 4),
          controller: otpController,
          length: 6,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.spaceEvenly,
          fieldWidth: 45,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 15,
          style: TextStyle(fontSize: 24),
          otpFieldStyle: OtpFieldStyle(
            backgroundColor: Color.fromARGB(255, 33, 33, 33),
            focusBorderColor: Colors.teal,
          ),
          onChanged: (pin) {
            print("Changed: " + pin);
            setState(() {
              code = int.parse(pin);
            });
          },
          onCompleted: (pin) {
            print("Completed: " + pin);
            setState(() {
              code = int.parse(pin);
            });
          },
        ),
      ],
    );
  }

  final TextEditingController _displayNameController = TextEditingController();

  Widget hostingSession(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _displayNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Group Name',
          ),
        ),
      ],
    );
  }
}
