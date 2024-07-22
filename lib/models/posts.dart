import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String videoUrl; // Add this field
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.videoUrl, // Add this parameter
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "videoUrl": videoUrl, // Add this field
        "profImage": profImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      videoUrl: snapshot['videoUrl'], // Add this field
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}




// class Post {
//   final String description;
//   final String uid;
//   final String username;
//   final String postId;
//   final datePublished;
//   final String postUrl;
//   final String profImage;
//   final likes;
//   Post(
//       {required this.description,
//       required this.uid,
//       required this.username,
//       required this.postId,
//       required this.datePublished,
//       required this.postUrl,
//       required this.profImage,
//       required this.likes});

//   Map<String, dynamic> toJson() => {
//         "description ": description,
//         "uid ": uid,
//         "username ": username,
//         "postId ": postId,
//         "datePublished ": datePublished,
//         "postUrl": postUrl,
//         "profImage ": profImage,
//         "likes ": likes,
//       };

//   // static Post fromSnap(DocumentSnapshot snap) {
//   //   var snapshot = snap.data() as Map<String, dynamic>;

//   //   return Post(
//   //     description: snapshot['description'] ?? '',
//   //     uid: snapshot['uid'] ?? '',
//   //     username: snapshot['username'] ?? '',
//   //     postId: snapshot['postId'] ?? '',
//   //     datePublished: snapshot['datePublished'] ?? '',
//   //     postUrl: snapshot['postUrl'] ?? '',
//   //     profImage: snapshot['profImage'] ?? [],
//   //     likes: snapshot['likes'] ?? [],
//   //   );
//   // }
// }
