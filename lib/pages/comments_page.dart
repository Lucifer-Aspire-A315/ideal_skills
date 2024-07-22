import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ideal_skills/resources/firestore_meths.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../utils/colors.dart';
import '../widgets/comment_card.dart';

class CommentsPage extends StatefulWidget {
  final Map<String, dynamic> snap;
  const CommentsPage({super.key, required this.snap, required String postId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    final String photo = user!.photoUrl;
    final String uname = user.username;
    final String uid = user.uid;
    final String postId = widget.snap['postId'];
    final String pimage = widget.snap['profImage'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as QuerySnapshot).docs[index].data()
                  as Map<String, dynamic>,
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(photo),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Comment As $uname",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    postId,
                    _commentController.text,
                    uid,
                    uname,
                    pimage,
                  );
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ideal_skills/resources/firestore_meths.dart';
// import 'package:provider/provider.dart';

// import '../provider/user_provider.dart';
// import '../utils/colors.dart';
// import '../widgets/comment_card.dart';

// class CommentsPage extends StatefulWidget {
//   final snap;
//   const CommentsPage({super.key, required this.snap});

//   @override
//   State<CommentsPage> createState() => _CommentsPageState();
// }

// class _CommentsPageState extends State<CommentsPage> {
//   final TextEditingController _commentController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     _commentController;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> user =
//         Provider.of<UserProvider>(context).getUser;
//     var photo, uname, pimage, uid, postId;

//     user.forEach((key, value) {
//       if (key.contains("photoUrl")) {
//         photo = value;
//       }
//       if (key.contains("username")) {
//         uname = value;
//       }
//       if (key.contains("uid")) {
//         uid = value;
//       }
//     });
//     print("user");
//     print(user);
//     print("hello");
//     print(widget.snap);

//     widget.snap.forEach((key, value) {
//       if (key.contains("postId")) {
//         postId = value;
//       }
//       if (key.contains("profImage")) {
//         pimage = value;
//       }
//     });
//     print("p");
//     print(postId);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: const Text("Comments"),
//         centerTitle: false,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(postId)
//             .collection('comments')
//             .orderBy('datePublished', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView.builder(
//             itemCount: (snapshot.data! as dynamic).docs.length,
//             itemBuilder: (context, index) => CommentCards(
//               snap: (snapshot.data! as dynamic).docs[index].data(),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           height: kToolbarHeight,
//           margin: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           padding: const EdgeInsets.only(left: 16, right: 8),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(photo!),
//                 radius: 18,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 18, right: 8),
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                       hintText: "Comment As ${uname!}",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () async {
//                   await FirestoreMethods().postComment(
//                       postId, _commentController.text, uid!, uname!, pimage!);
//                   setState(() {
//                     _commentController.text = "";
//                   });
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                   child: const Text(
//                     "Post",
//                     style: TextStyle(
//                       color: blueColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
