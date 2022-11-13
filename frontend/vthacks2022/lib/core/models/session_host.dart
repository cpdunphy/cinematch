import 'package:flutter/foundation.dart';
import 'package:vthacks2022/core/models/media.dart';

// Create a session class
@immutable
class SessionHost {
  SessionHost({required this.id, required this.name, required this.code});

  final String id;
  final String name;
  final int code;
  List<Media> reconciledTitles = [];

  SessionHost.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          code: json['code']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'reconciledTitles': reconciledTitles.map((e) => e.toJson()).toList(),
    };
  }
}
