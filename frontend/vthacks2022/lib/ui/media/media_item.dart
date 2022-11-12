import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
          Text("Rating: ${media.voteAverage / 2} / 5"),
          RatingBar(
            itemCount: 5,
            direction: Axis.horizontal,
            ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: Colors.orange),
                half: const Icon(
                  Icons.star_half,
                  color: Colors.orange,
                ),
                empty: const Icon(
                  Icons.star_outline,
                  color: Colors.orange,
                )),
            onRatingUpdate: (double value) {},
          ),
          Image.network(media.posterUrl),
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
