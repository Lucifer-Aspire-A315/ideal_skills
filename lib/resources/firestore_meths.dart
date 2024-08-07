import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ideal_skills/models/posts.dart';
import 'package:ideal_skills/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage,
      {required bool isVideo}) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        videoUrl: '', // No video URL for image posts
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profImage) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profimage": profImage,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uploadVideo(String description, XFile videoFile, String uid,
      String username, String profImage) async {
    String res = "Some error occurred";
    try {
      String videoUrl = await StorageMethods()
          .uploadVideoToStorage('posts', File(videoFile.path), true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: '', // No image URL for video posts
        videoUrl: videoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}




// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ideal_skills/models/posts.dart';
// import 'package:ideal_skills/resources/storage_methods.dart';
// import 'package:uuid/uuid.dart';

// class FirestoreMeths {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> uploadPost(String description, Uint8List file, String uid,
//       String username, String profImage) async {
//     String res = "some error occurred..";
//     try {
//       String photoUrl =
//           await StorageMethods().uploadImageToStorage("posts", file, true);

//       String postId = const Uuid().v1();
//       Post post = Post(
//         description: description,
//         uid: uid,
//         username: username,
//         postId: postId,
//         datePublished: DateTime.now(),
//         postUrl: photoUrl,
//         profImage: profImage,
//         likes: [],
//       );

//       _firestore.collection("posts").doc(postId).set(
//             post.toJson(),
//           );
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }

//     return res;
//   }

//   Future<void> likePost(String postId, String uid, List likes) async {
//     try {
//       if (likes.contains(uid)) {
//         await _firestore.collection("posts").doc(postId).update({
//           'likes': FieldValue.arrayRemove([uid]),
//         });
//       } else {
//         await _firestore.collection("posts").doc(postId).update({
//           'likes': FieldValue.arrayUnion([uid]),
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<void> postComment(String postId, String text, String uid, String name,
//       String profImage) async {
//     try {
//       if (text.isNotEmpty) {
//         String commentId = Uuid().v1();
//         await _firestore
//             .collection("posts")
//             .doc(postId)
//             .collection("comments")
//             .doc(commentId)
//             .set({
//           "profimage": profImage,
//           "name": name,
//           "uid": uid,
//           "text": text,
//           "commentId": commentId,
//           "datePublished": DateTime.now(),
//         });
//       } else {
//         print("Text is empty");
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   //deleting posts

//   Future<void> deletePost(String postId) async {
//     try {
//       await _firestore.collection('posts').doc(postId).delete();
//     } catch (err) {
//       print(err.toString());
//     }
//   }
// }
