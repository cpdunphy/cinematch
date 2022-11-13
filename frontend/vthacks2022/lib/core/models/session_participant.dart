import 'package:flutter/foundation.dart';
import 'package:vthacks2022/core/models/session_host.dart';
import 'package:vthacks2022/core/models/user_object.dart';
import 'package:vthacks2022/core/models/media.dart';

// Create a session participant class to represent a user's participation in a session
@immutable
class SessionParticipant {
  SessionParticipant({
    required this.sessionCode,
    required this.user,
    this.mediaList = const [],
  });

  final int sessionCode;
  final UserObject user;
  List<String> mediaList;

  SessionParticipant.fromJson(Map<String, Object?> json)
      : this(
          sessionCode: json['sessionCode']! as int,
          user: UserObject.fromJson(json['user']! as Map<String, dynamic>),
          mediaList: (json['mediaList']! as List).cast<String>(),
        );

  Map<String, Object?> toJson() {
    return {
      'sessionCode': sessionCode,
      'user': user.toJson(),
      'mediaList': mediaList,
    };
  }
}
