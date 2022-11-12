import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/session_participant.dart';
import '../models/session.dart';
import '../models/user_object.dart';
import '../models/media.dart';
import 'package:uuid/uuid.dart';

// Provider Class for Session Participant Service
class SessionParticipantService extends ChangeNotifier {
  final mediaRef = FirebaseFirestore.instance
      .collection("session_participants")
      .withConverter<SessionParticipant>(
        fromFirestore: (snapshot, _) =>
            SessionParticipant.fromJson(snapshot.data()!),
        toFirestore: (sessionParticipant, _) => sessionParticipant.toJson(),
      );

  final List<Media> _swipedMedia = [];

  List<Media> get swipedMedia => _swipedMedia;

  // Create a new session participant by session and uder (join session button)
  Future<SessionParticipant?> createSessionParticipant(
      Session session, UserObject userObject) async {
    const uuid = Uuid();

    final sessionParticipant = SessionParticipant(
      uid: uuid.v4(),
      session: session,
      user: userObject,
      mediaList: [],
    );

    final ref =
        await mediaRef.doc(sessionParticipant.uid).set(sessionParticipant);

    return Future.value(sessionParticipant);
  }

  // Modify session participant to set swiped media
  Future<SessionParticipant?> modifySessionParticipant(
      SessionParticipant sessionParticipant) async {
    final ref = await mediaRef
        .doc(sessionParticipant.uid)
        .update({'mediaList': FieldValue.arrayUnion(swipedMedia)});

    return Future.value(sessionParticipant);
  }

  // Swipe right on a media
  Future<void> swipeRight(Media media) async {
    _swipedMedia.add(media);
    notifyListeners();
  }
}
