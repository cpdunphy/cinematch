import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/media.dart';

// Provider Class for Media Service
class MediaService extends ChangeNotifier {
  final mediaRef =
      FirebaseFirestore.instance.collection('titles').withConverter<Media>(
            fromFirestore: (snapshots, _) =>
                Media.fromJson(snapshots.data()!, snapshots.id),
            toFirestore: (media, _) => media.toJson(),
          );

  List<Media> _mediaList = [];

  List<Media> get mediaList => _mediaList;

  // Fetch first 10 media from Firestore
  Future<void> getMedia() async {
    final media =
        await mediaRef.orderBy("popularity", descending: true).limit(10).get();
    _mediaList.addAll(media.docs.map((e) => e.data()).toList());
    notifyListeners();
  }

  // Fetch next 10 media from Firestore
  Future<void> getNextMedia() async {
    final media = await mediaRef
        .orderBy("popularity", descending: true)
        .startAfter([_mediaList.last.popularity])
        .limit(10)
        .get();
    _mediaList.addAll(media.docs.map((e) => e.data()).toList());
    notifyListeners();
  }
}
