import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/session_host.dart';
import 'package:uuid/uuid.dart';
import 'package:vthacks2022/core/models/media.dart';

// Provider Class for Session Service
class SessionHostService extends ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;

  late SessionHost _currentSession;
  SessionHost get currentSession => _currentSession;

  // Create a session
  Future<void> createSession(String name) async {
    const uuid = Uuid();

    var code = Random().nextInt(900000) + 100000;

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
    // Get a query snapshot of each participants media list and store as list of lists
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('sessions')
        .doc(_currentSession.id)
        .collection('participants')
        .get();

    // var mediaLists = querySnapshot.docs
    //     .map((doc) => doc.data()['mediaList'] as List<String>)
    //     .toList();

    List mediaList = [];

    for (var doc in querySnapshot.docs) {
      mediaList.addAll(doc['mediaList']);
    }

    // Count occurances of each media in the mediaList
    final Map mediaCount = {};
    for (var media in mediaList) {
      if (mediaCount.containsKey(media)) {
        mediaCount[media] = mediaCount[media]! + 1;
      } else {
        mediaCount[media] = 1;
      }
    }

    // Retrieve the key from mediaCount with the highest value
    var winnerKey = mediaCount.entries
        .reduce((e1, e2) => e1.value > e2.value ? e1 : e2)
        .key;

    //Query firestore titles collection for document with id of winnerKey
    Media winner = await _firebaseFirestore
        .collection('titles')
        .doc(winnerKey)
        .get()
        .then((value) => Media.fromJson(value.data()!, value.id));

    return Future.value(winner);
  }
}
