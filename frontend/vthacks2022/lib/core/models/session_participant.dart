import 'package:flutter/foundation.dart';
import 'package:vthacks2022/core/models/session.dart';
import 'package:vthacks2022/core/models/user_object.dart';
import 'package:vthacks2022/core/models/media.dart';

// Create a session participant class to represent a user's participation in a session
@immutable
class SessionParticipant {
  const SessionParticipant({
    required this.uid,
    required this.session,
    required this.user,
    required this.mediaList,
  });

  final String uid;
  final Session session;
  final UserObject user;
  final List<Media> mediaList;

  SessionParticipant.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          session: Session.fromJson(json['session']! as Map<String, Object?>),
          user: UserObject.fromJson(json['user']! as Map<String, Object?>),
          mediaList: (json['mediaList']! as List)
              .map((e) => Media.fromJson(e as Map<String, Object?>))
              .toList(),
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'session': session.toJson(),
      'user': user.toJson(),
      'mediaList': mediaList.map((e) => e.toJson()).toList(),
    };
  }
}
