import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/models/media.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';
import 'package:vthacks2022/core/services/media_service.dart';
import 'package:vthacks2022/core/services/session_host_service.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:vthacks2022/ui/explore.dart';
import 'package:vthacks2022/ui/session/session_result.dart';
import 'package:vthacks2022/ui/session/session_waiting.dart';
import 'package:vthacks2022/ui/session/swiping.dart';
import '../../../../core/models/session_host.dart';

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  bool isJoiningSession = true;

  @override
  void initState() {
    super.initState();
  }

  bool loadedData = false;

  @override
  Widget build(BuildContext context) {
    SessionParticipantService participantService =
        Provider.of<SessionParticipantService>(context);
    MediaService mediaService = Provider.of<MediaService>(context);

    if (!loadedData) {
      mediaService.getMedia();
      loadedData = true;
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("CINEMATCH"),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () {
      //         authService.signOutUser();
      //       },
      //     )
      //   ],
      // ),
      body: body(context, participantService.swipeState),
    );
  }

  Widget body(BuildContext context, SwipeState state) {
    switch (state) {
      case SwipeState.swiping:
        return Swipping(
          swipeState: state,
        );
      case SwipeState.waiting:
        return SessionWaiting();
      case SwipeState.gallery:
        return home(context);
      case SwipeState.result:
        return SessionResult();
    }
  }

  Widget home(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // pinned: true,
          // snap: true,
          // floating: _floating,
          expandedHeight: 80.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('CINEMATCH'),
            background: FlutterLogo(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authService.signOutUser();
              },
              // alignment: Alignment.centerLeft,
            )
          ],
        ),
        SliverToBoxAdapter(
          child: form(context),
        ),
        explore(context),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            width: 40,
          ),
        )
      ],
    );
  }

  Widget explore(BuildContext context) {
    MediaService value = Provider.of<MediaService>(context);

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        ((context, index) {
          return Container(
            height: 180,
            width: 180,
            child: TextButton(
              child: Card(
                child: Image.network(
                  value.mediaList[index].posterUrl,
                  fit: BoxFit.fitHeight,
                ),
              ),
              onPressed: () {
                AlertDialog(
                  title: Text(value.mediaList[index].title),
                  content: Text(value.mediaList[index].overview),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            ),
          );
        }),
        childCount: value.mediaList.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
    );
  }

  Widget form(BuildContext context) {
    SessionHostService sessionHostService =
        Provider.of<SessionHostService>(context);

    SessionParticipantService participantService =
        Provider.of<SessionParticipantService>(context);

    AuthenticationService authService =
        Provider.of<AuthenticationService>(context);

    MediaService mediaService = Provider.of<MediaService>(context);
    return Column(
      children: [
        Row(
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
        const Divider(color: Colors.white38),
        const SizedBox(
          height: 8,
        ),
        isJoiningSession ? joiningSession(context) : hostingSession(context),
        Container(
          child: ElevatedButton(
            onPressed: () async {
              if (isJoiningSession) {
                await participantService.createSessionParticipant(
                    code, authService.customUser);
                participantService.setSwipeState(SwipeState.swiping);
              } else {
                var name = _displayNameController.text;
                await sessionHostService.createSession(name);
                await participantService.createSessionParticipant(
                    sessionHostService.currentSession.code,
                    authService.customUser);
                participantService.setSwipeState(SwipeState.swiping);
              }
            },
            style: style,
            child: Text(
              isJoiningSession ? "JOIN SESSION" : "HOST SESSION",
            ),
          ),
        ),
        const Divider(height: 12, color: Colors.white38),
        const SizedBox(height: 8)
      ],
    );
  }

  int code = 0;

  OtpFieldController otpController = OtpFieldController();

  Widget joiningSession(BuildContext context) {
    return Column(
      children: [
        Text("Enter Session Code"),
        SizedBox(height: 8),
        OTPTextField(
          contentPadding: EdgeInsets.fromLTRB(8, 24, 8, 4),
          controller: otpController,
          length: 6,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.spaceEvenly,
          fieldWidth: 45,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 15,
          style: TextStyle(fontSize: 18),
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
