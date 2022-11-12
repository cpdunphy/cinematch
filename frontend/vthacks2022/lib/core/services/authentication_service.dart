import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:vthacks2022/core/models/user_object.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  uninitialized,
  authenticating,
}

class AuthenticationService extends ChangeNotifier {
  AuthenticationStatus status = AuthenticationStatus.uninitialized;

  init() {
    // verifyAuthStatus();
  }

  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Auth_Service: $e');
      return false;
    }
  }

  // Get credentials of current user
  void verifyAuthStatus() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        status = AuthenticationStatus.authenticated;
        // notifyListeners();
      } else {
        status = AuthenticationStatus.unauthenticated;
        // notifyListeners();
      }
    } catch (e) {
      status = AuthenticationStatus.unauthenticated;
      // notifyListeners();
    }
  }

  late UserObject _customUser;

  UserObject get customUser => _customUser;

// Function to create a new user document in Firestore and register a user with Firebase Authentication
  Future<void> registerUser(
    String displayName,
    String email,
    String password,
  ) async {
    status = AuthenticationStatus.authenticating;
    notifyListeners();

    try {
      // Create a new user account in Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's uid
      final String uid = userCredential.user!.uid;

      // Get the user's gravatar image url
      final Gravatar gravatar = Gravatar(email);
      final String photoUrl = gravatar.imageUrl();

      // Create a new user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
      });

      _customUser = UserObject(
          displayName: displayName, email: email, photoUrl: photoUrl, uid: uid);

      status = AuthenticationStatus.authenticated;
      notifyListeners();
    } catch (e) {
      print("Account creation failed $e");
      status = AuthenticationStatus.unauthenticated;
      notifyListeners();
    }
  }

// Function to sign in a user with Firebase Authentication
  Future<void> signInUser(String email, String password) async {
    status = AuthenticationStatus.authenticating;
    notifyListeners();

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Call fromJson to create a new User object
      // final user = UserObject.fromJson(
      //   (await FirebaseFirestore.instance
      //           .collection('users')
      //           .doc(userCredential.user!.uid)
      //           .get())
      //       .data()!,
      // );

      print(userCredential.user!.uid);

      // Pull the user's data from Firestore and put into _customUser
      _customUser = UserObject.fromJson((await _firebaseFirestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get())
          .data()!);
      //      ??
      // {
      //   'uid': 'L9BcmA6txLPLSGAJQmrMJh2zC142',
      //   'displayName': 'Ryan',
      //   'email': 'rpg@vt.edu',
      // });

      status = AuthenticationStatus.authenticated;
      notifyListeners();

      // Return a future with the user object
      // return Future.value(user);
    } catch (e) {
      print("Sign in failed ${e.toString()}");
      status = AuthenticationStatus.unauthenticated;
      notifyListeners();
      // return Future.value(null);
    }
  }

// Function to sign out a user with Firebase Authentication
  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
    status = AuthenticationStatus.unauthenticated;
    notifyListeners();
  }
}
