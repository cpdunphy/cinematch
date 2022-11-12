import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';

// Function to create a new user document in Firestore and register a user with Firebase Authentication
Future<void> registerUser(
  String email,
  String password,
  String username,
  String phoneNumber,
  String? firstName,
  String? lastName,
) async {
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
    'email': email,
    'username': username,
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
    'photoUrl': photoUrl,
  });
}

// Function to sign in a user with Firebase Authentication
Future<void> signInUser(String email, String password) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

// Function to sign out a user with Firebase Authentication
Future<void> signOutUser() async {
  await FirebaseAuth.instance.signOut();
}
