import 'package:flutter/foundation.dart';

// Create a session class
@immutable
class Session {
  const Session({
    required this.uid,
    required this.name,
    required this.locked,
    required this.streamingServices,
  });

  final String uid;
  final String name;
  final bool locked; // true if it's a locked sessions
  final List<String> streamingServices;

  Session.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          name: json['name']! as String,
          locked: json['locked']! as bool,
          streamingServices: json['streamingServices']! as List<String>,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'name': name,
      'locked': locked,
      'streamingServices': streamingServices,
    };
  }
}
