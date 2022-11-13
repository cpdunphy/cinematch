import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/session_participant.dart';
import '../models/session_host.dart';
import '../models/user_object.dart';
import '../models/media.dart';
import 'package:uuid/uuid.dart';

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

  late String participatingSessionCode;

  // Create a new session participant by session and uder (join session button)
  Future<SessionParticipant?> createSessionParticipant(
      int sessionCode, UserObject userObject) async {
    const uuid = Uuid();

    final sessionParticipant = SessionParticipant(
      sessionCode: sessionCode,
      user: userObject,
    );

    // Query the session by session code
    final documentRef = await _firebaseFirestore
        .collection("session_hosts/$sessionCode/participants")
        .add(sessionParticipant.toJson());

    participatingSessionCode = documentRef.id;
  }

  // Modify session participant to set swiped media
  Future<SessionParticipant?> modifySessionParticipant(
      SessionParticipant sessionParticipant) async {
    final ref = await _firebaseFirestore
        .collection("sesson_hosts/")
        .doc(participatingSessionCode)
        .update({'mediaList': FieldValue.arrayUnion(swipedMedia)});

    return Future.value(sessionParticipant);
  }

  // Swipe right on a media
  Future<void> swipeRight(Media media) async {
    _swipedMedia.add(media);
    notifyListeners();
  }
}
