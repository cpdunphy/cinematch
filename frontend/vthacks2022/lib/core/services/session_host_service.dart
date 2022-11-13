import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/session_host.dart';
import 'package:uuid/uuid.dart';
import 'package:vthacks2022/core/models/media.dart';

// Provider Class for Session Service
class SessionHostService extends ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;

  late SessionHost _currentSession;

  // Create a session
  Future<void> createSession(String name, int code) async {
    const uuid = Uuid();

    final session = SessionHost(
      id: uuid.v4(),
      name: name,
      code: code,
    );

    await _firebaseFirestore
        .collection('sessions')
        .doc(session.id)
        .set(session.toJson());

    _currentSession = session;

    // Assume subsequent call to joinSession
  }

  // Reconcile the results of a session at the end of the session
  Future<Media> reconcileSession() async {
    Media reccomended =
        (_currentSession.reconciledTitles.toList()..shuffle()).first;
    return Future.value(reccomended);
  }
}
