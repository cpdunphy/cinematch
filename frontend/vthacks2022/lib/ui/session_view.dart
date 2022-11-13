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
import 'package:vthacks2022/core/services/session_host_service.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';
import 'package:otp_text_field/otp_text_field.dart';
import '../core/models/session_host.dart';

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  bool isJoiningSession = true;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _sessionCodeController =
        TextEditingController();

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
            Divider(color: Colors.white38),
            SizedBox(
              height: 24,
            ),
            isJoiningSession ? JoinSession() : HostSession()
          ],
        ),
      ),
    );
  }
}

class JoinSession extends StatefulWidget {
  const JoinSession({super.key});

  @override
  State<JoinSession> createState() => _JoinSessionState();
}

class _JoinSessionState extends State<JoinSession> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  @override
  Widget build(BuildContext context) {
    SessionParticipantService sessionParticipantService =
        Provider.of<SessionParticipantService>(context);
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context);

    var code = 0;

    OtpFieldController otpController = OtpFieldController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
          },
          onCompleted: (pin) {
            print("Completed: " + pin);
            setState(() {
              code = int.parse(pin);
            });
          },
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              sessionParticipantService.createSessionParticipant(
                  code, authService.customUser);
            },
            child: const Text("JOIN SESSION"),
            style: style,
          ),
        ),
      ],
    );
  }
}

class HostSession extends StatefulWidget {
  const HostSession({super.key});

  @override
  State<HostSession> createState() => _HostSessionState();
}

class _HostSessionState extends State<HostSession> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  TextEditingController _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SessionHostService sessionHostService =
        Provider.of<SessionHostService>(context);

    return Column(
      children: [
        TextField(
          controller: _displayNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Group Name',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            var name = _displayNameController.text;
            var code = Random().nextInt(900000) + 100000;
            sessionHostService.createSession(name, code);
          },
          child: const Text("CREATE SESSION"),
          style: style,
        ),
      ],
    );
  }
}
