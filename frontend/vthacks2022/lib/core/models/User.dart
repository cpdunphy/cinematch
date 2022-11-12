import 'package:flutter/foundation.dart';

// Create a user class
@immutable
class User {
  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String username;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;

  User.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          email: json['email']! as String,
          username: json['username']! as String,
          phoneNumber: json['phoneNumber']! as String,
          firstName: json['firstName']! as String,
          lastName: json['lastName']! as String,
          photoUrl: json['photoUrl']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
    };
  }
}
