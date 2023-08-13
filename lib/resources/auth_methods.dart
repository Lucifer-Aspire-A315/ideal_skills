import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ideal_skills/resources/storage_methods.dart';
import 'package:ideal_skills/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<model.User> getUserDetails() async {
  //   User currentUserr = _auth.currentUser!;

  //   DocumentSnapshot snap =
  //       await _firestore.collection('users').doc(currentUserr.uid).get();

  //   return model.User.fromSnap(snap);
  //   // return model.User(
  //   //   username: (snap.data() as Map<String, dynamic>)['username'] ?? '',
  //   //   uid: (snap.data() as Map<String, dynamic>)['uid'] ?? '',
  //   //   email: (snap.data() as Map<String, dynamic>)['email'] ?? '',
  //   //   bio: (snap.data() as Map<String, dynamic>)['bio'] ?? '',
  //   //   photoUrl: (snap.data() as Map<String, dynamic>)['photoUrl'] ?? '',
  //   //   followers: (snap.data() as Map<String, dynamic>)['followers'] ?? [],
  //   //   following: (snap.data() as Map<String, dynamic>)['following'] ?? [],
  //   // );
  // }

  Future<Map<String, dynamic>?> getUserDetails() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    Uint8List? file,
  }) async {
    String res = "Some error occurred !!";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // ||file != null
          ) {
        //register  User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("ProfilePics", file!, false);

        // add user to database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Log in user

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
