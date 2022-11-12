import 'package:flutter/foundation.dart';

enum MediaType {
  movie,
  tv,
}

// Genres {
//   crime,
// }

@immutable
class Media {
  Media({
    required this.backdropUrlString,
    required this.genre,
    required this.mediaType,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterUrlString,
    required this.services,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  final String title;
  final MediaType mediaType;
  final String backdropUrlString;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final String posterUrlString;
  final List<String> services;
  final List<String> genre;
  final double voteAverage;
  final int voteCount;

  Media.fromJson(Map<String, Object?> json)
      : this(
          backdropUrlString: json["backdrop_path"]! as String,
          genre: (json['genres']! as List).cast<String>(),
          mediaType: MediaType.values.firstWhere((e) =>
              e.toString() == 'MediaType.' + (json["media_type"]! as String)),
          originalLanguage: json["original_language"]! as String,
          originalTitle: json['original_title']! as String,
          overview: json['overview']! as String,
          posterUrlString: json['poster_path']! as String,
          services: (json['streaming_services']! as List).cast<String>(),
          title: json['title']! as String,
          voteAverage: json['vote_average']! as double,
          voteCount: json['vote_count']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'backdrop_path': backdropUrlString,
      'genres': genre,
      'media_type': mediaType,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'poster_path': posterUrlString,
      'streaming_services': services,
      'title': title,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
