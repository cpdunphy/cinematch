import 'package:flutter/foundation.dart';

// Create a session class
@immutable
class Session {
  const Session({required this.id, required this.name, required this.code});

  final String id;
  final String name;
  final int code;

  Session.fromJson(Map<String, Object?> json)
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
    };
  }
}
