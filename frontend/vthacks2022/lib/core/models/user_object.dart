import 'package:flutter/foundation.dart';

// Create a user class
@immutable
class UserObject {
  const UserObject({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;

  UserObject.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          email: json['email']! as String,
          displayName: json['displayName']! as String,
          photoUrl: json['photoUrl']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
