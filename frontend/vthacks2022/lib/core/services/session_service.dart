import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/session.dart';

// Provider Class for Session Service
class SessionService extends ChangeNotifier {
  final mediaRef =
      FirebaseFirestore.instance.collection('sessions').withConverter<Session>(
            fromFirestore: (snapshot, _) => Session.fromJson(snapshot.data()!),
            toFirestore: (session, _) => session.toJson(),
          );

  final List<Session> _openSessions = [];

  List<Session> get openSessions => _openSessions;

  // Fetch first 10 sessions from Firestore
  Future<void> getSessions() async {
    final sessions = await mediaRef.limit(10).get();
    _openSessions.addAll(sessions.docs.map((e) => e.data()));
    notifyListeners();
  }

  // Fetch next 10 sessions from Firestore
  Future<void> getNextSessions() async {
    final sessions =
        await mediaRef.startAfter([_openSessions.last]).limit(10).get();
    _openSessions.addAll(sessions.docs.map((e) => e.data()));
    notifyListeners();
  }

  // Get a specific session from Firestore and overwrite _openSessions
  Future<void> getSession(String id) async {
    final session = await mediaRef.doc(id).get();
    _openSessions.clear();
    _openSessions.add(session.data()!);
    notifyListeners();
  }

  // Add a new session to Firestore and treat it as a joined session
  Future<void> addSession(Session session) async {
    final newSession = await mediaRef.add(session);
    // Retrieve the newSession from Firestore and overwrite _openSessions
    getSession(newSession.id);
  }
}
