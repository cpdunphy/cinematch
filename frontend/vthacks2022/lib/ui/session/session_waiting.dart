import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/models/session_participant.dart';

import '../../core/services/session_participant_service.dart';

class SessionWaiting extends StatelessWidget {
  const SessionWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    SessionParticipantService participantService =
        Provider.of<SessionParticipantService>(context);
    // TODO: Show users, code, time?
    var code = participantService.participatingSessionCode;
    return Scaffold(
      appBar: AppBar(
        title: Text("Session Code $code"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              participantService.setSwipeState(SwipeState.gallery);
            },
            alignment: Alignment.centerLeft,
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text("Waiting for Group $code Participants to Finish"),
              ElevatedButton(
                child: Text("Is everyone finished?"),
                onPressed: () {
                  participantService.setSwipeState(SwipeState.result);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
