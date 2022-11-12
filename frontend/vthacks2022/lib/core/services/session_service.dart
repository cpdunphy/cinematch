import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/session.dart';
import 'package:uuid/uuid.dart';

// Provider Class for Session Service
class SessionService extends ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // Create a session
  Future<void> createSession(String name, int code) async {
    const uuid = Uuid();

    final session = Session(
      id: uuid.v4(),
      name: name,
      code: code,
    );

    await _firebaseFirestore
        .collection('sessions')
        .doc(session.id)
        .set(session.toJson());
  }
}
