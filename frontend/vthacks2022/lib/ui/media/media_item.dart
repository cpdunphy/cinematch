import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/models/media.dart';
import '../../core/models/media_streaming_services.dart';

class MediaItem extends StatelessWidget {
  MediaItem(this.media, {super.key});

  final Media media;
  // final DocumentReference<Media> reference;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            media.title ?? "Error",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            media.overview ?? "Error",
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          // Image.network(media.posterUrl),

          Wrap(
            direction: Axis.horizontal,
            spacing: 8.0,
            runSpacing: 8.0,
            children: media.services.map((e) {
              return Text(MediaStreamingServicesUI.displayName(e));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
