import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vthacks2022/ui/session/swiping.dart';
import '../models/session_participant.dart';
import '../models/session_host.dart';
import '../models/user_object.dart';
import '../models/media.dart';
import 'package:uuid/uuid.dart';

enum SwipeState { swiping, waiting, gallery, result }

// Provider Class for Session Participant Service
class SessionParticipantService extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // final mediaRef = FirebaseFirestore.instance
  //     .collection("session_participants")
  //     .withConverter<SessionParticipant>(
  //       fromFirestore: (snapshot, _) =>
  //           SessionParticipant.fromJson(snapshot.data()!),
  //       toFirestore: (sessionParticipant, _) => sessionParticipant.toJson(),
  //     );

  final List<Media> _swipedMedia = [];
  List<Media> get swipedMedia => _swipedMedia;

  var numSwipes = 0;

  late String participantId;
  late int participatingSessionCode;
  String _sessionId = "";
  String get sessionId => _sessionId;

  SwipeState _swipeState = SwipeState.gallery;

  SwipeState get swipeState => _swipeState;

  // Set swipe State
  void setSwipeState(SwipeState state) {
    _swipeState = state;
    notifyListeners();
  }

  // Create a new session participant by session and uder (join session button)
  Future<void> createSessionParticipant(
      int sessionCode, UserObject userObject) async {
    final sessionParticipant = SessionParticipant(
      sessionCode: sessionCode,
      user: userObject,
    );

    // Query Firestore for document that has the code sessionCode
    final sessionQuery = await _firebaseFirestore
        .collection('sessions')
        .withConverter<SessionHost>(
          fromFirestore: (snapshots, _) =>
              SessionHost.fromJson(snapshots.data()!),
          toFirestore: (sessionHost, _) => sessionHost.toJson(),
        )
        .where('code', isEqualTo: sessionCode)
        .get();

    _sessionId = sessionQuery.docs.first.id;

    // Adda session participant
    final documentRef = await _firebaseFirestore
        .collection("sessions")
        .doc(_sessionId)
        .collection("participants")
        .add(sessionParticipant.toJson());

    participantId = documentRef.id;
    participatingSessionCode = sessionCode;
    await Clipboard.setData(ClipboardData(text: "$sessionCode"));
  }

  // Modify session participant to set swiped media
  Future<void> _modifySessionParticipant() async {
    List<String> swipedMediaIds = _swipedMedia.map((e) => e.id).toList();

    // Query Firestore for document that has the code sessionCode
    _sessionId = await _firebaseFirestore
        .collection('sessions')
        .withConverter<SessionHost>(
          fromFirestore: (snapshots, _) =>
              SessionHost.fromJson(snapshots.data()!),
          toFirestore: (sessionHost, _) => sessionHost.toJson(),
        )
        .where('code', isEqualTo: participatingSessionCode)
        .get()
        .then((value) => value.docs.first.id);

    // print(swipedMediaIds);
    await _firebaseFirestore
        .collection("sessions")
        .doc(_sessionId)
        .collection("participants")
        .doc(participantId)
        .set({
      'mediaList': swipedMediaIds,
    }, SetOptions(merge: true));
  }

  // Swipe right on a media
  Future<void> swipeRight(Media media) async {
    _swipedMedia.add(media);
    _addSwipe();
    notifyListeners();
  }

  // Swipe left on a media
  Future<void> swipeLeft(Media media) async {
    _addSwipe();
    notifyListeners();
  }

  // Add a swipe helper function
  void _addSwipe() async {
    numSwipes++;
    if (numSwipes >= 20) {
      _modifySessionParticipant();
      _swipeState = SwipeState.waiting;
    }
  }

  // Stream<List<SessionParticipant>> participantsStream() {
  //   FirebaseFirestore.instance
  //       .collection("sessions")
  //       .doc(_sessionId)
  //       .collection("participants")
  //       .withConverter<SessionParticipant>(
  //         fromFirestore: (snapshots, _) =>
  //             SessionParticipant.fromJson(snapshots.data()!),
  //         toFirestore: (part, _) => part.toJson(),
  //       )
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
  // } as Stream<List<SessionParticipant>>;
}
