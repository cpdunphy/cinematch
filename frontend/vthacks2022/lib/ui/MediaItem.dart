import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/models/Media.dart';

class MediaItem extends StatelessWidget {
  MediaItem(this.media, this.reference, {super.key});

  final Media media;
  final DocumentReference<Media> reference;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        media.title ?? "Error",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
