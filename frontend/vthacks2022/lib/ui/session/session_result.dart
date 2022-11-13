import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/models/session_participant.dart';
import 'package:vthacks2022/core/services/authentication_service.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';

import '../../core/models/media.dart';
import '../../core/services/session_host_service.dart';

class SessionResult extends StatelessWidget {
  const SessionResult({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Show users, code, time?

    SessionParticipantService sessionParticipant =
        Provider.of<SessionParticipantService>(context);
    SessionHostService sessionHostService =
        Provider.of<SessionHostService>(context);
    var code = sessionParticipant.participatingSessionCode;
    return Scaffold(
      appBar: AppBar(
        title: Text("Session Code $code"),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<Media>(
                future: sessionHostService.reconcileSession(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("The result is ${snapshot.data.toString()}");
                  } else {
                    return Text("${snapshot.error}");
                  }
                }),
            ElevatedButton(
              child: const Text("Return to Gallery"),
              onPressed: () {
                sessionParticipant.setSwipeState(SwipeState.gallery);
              },
            )
          ],
        ),
      ),
    );
  }
}
