import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String photoUrl;
  final List<dynamic> followers;
  final List<dynamic> following;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  // Create User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      followers: List<dynamic>.from(map['followers'] ?? []),
      following: List<dynamic>.from(map['following'] ?? []),
    );
  }

  // Create User object from a Firestore DocumentSnapshot
  factory User.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'] ?? '',
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      bio: snapshot['bio'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      followers: List<dynamic>.from(snapshot['followers'] ?? []),
      following: List<dynamic>.from(snapshot['following'] ?? []),
    );
  }
}


  // static User fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return User(
  //     username: snapshot['username'],
  //     uid: snapshot['uid'],
  //     email: snapshot['email'],
  //     bio: snapshot['bio'],
  //     photoUrl: snapshot['photoUrl'],
  //     followers: snapshot['followers'],
  //     following: snapshot['following'],
  //   );
  // }
