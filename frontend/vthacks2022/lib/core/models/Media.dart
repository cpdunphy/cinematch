import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vthacks2022/core/models/media_services.dart';
import 'package:vthacks2022/core/models/MediaType.dart';

@immutable
class Media {
  Media({
    required this.backdropUrl,
    required this.genre,
    // required this.id,
    required this.mediaType,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterUrl,
    required this.releaseDate,
    required this.services,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  final String backdropUrl;
  final List<String> genre;
  // final String id;
  final MediaType mediaType;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final String posterUrl;
  final Timestamp releaseDate;
  final List<MediaServices> services;
  final String title;
  final double voteAverage;
  final int voteCount;

  Media.fromJson(Map<String, Object?> json)
      : this(
          backdropUrl: json["backdrop_path"]! as String,
          genre: (json['genres']! as List).cast<String>(),
          // id: json['uid']! as String,
          mediaType: MediaType.values.firstWhere((e) =>
              e.toString() == 'MediaType.' + (json["media_type"]! as String)),
          originalLanguage: json["original_language"]! as String,
          originalTitle: json['original_title']! as String,
          overview: json['overview']! as String,
          posterUrl: json['poster_path']! as String,
          releaseDate: json['release_date']! as Timestamp,
          services: (json['streaming_services']! as List).cast<MediaServices>(),
          title: json['title']! as String,
          voteAverage: json['vote_average']! as double,
          voteCount: json['vote_count']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'backdrop_path': backdropUrl,
      'genres': genre,
      // 'uid': id,
      'media_type': mediaType,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'poster_path': posterUrl,
      'release_date': releaseDate,
      'streaming_services': services,
      'title': title,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
