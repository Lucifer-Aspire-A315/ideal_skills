// this is the one
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ideal_skills/provider/user_provider.dart';
import 'package:ideal_skills/resources/firestore_meths.dart';
import 'package:ideal_skills/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../pages/comments_page.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  late String postId;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    postId = widget.snap['postId'];
    getComments();
    print(widget.snap['videoUrl']);
    if (widget.snap['videoUrl'] != null) {
      // Corrected the initialization of VideoPlayerController
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.snap['videoUrl']))
            ..initialize().then((_) {
              setState(() {});
              _videoController!.setLooping(true);
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      setState(() {
        commentLength = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.getUser;
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final String profile = widget.snap['profImage'] ?? '';
        final String desc = widget.snap['description'] ?? '';
        final String uname = widget.snap['username'] ?? '';
        final String postUrl = widget.snap['postUrl'] ?? '';
        final List likes = widget.snap['likes'] ?? [];
        final Timestamp datePublished =
            widget.snap['datePublished'] ?? Timestamp.now();
        final String uid = user.uid;

        return Container(
          color: mobileBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                    .copyWith(right: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(profile),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              uname,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // More options
                  ],
                ),
              ),
              // Media section
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_videoController != null)
                      _videoController!.value.isInitialized
                          ? VisibilityDetector(
                              key: const Key('video-player-key'),
                              onVisibilityChanged: (visibilityInfo) {
                                if (visibilityInfo.visibleFraction > 0.5) {
                                  _videoController!.play();
                                } else {
                                  _videoController!.pause();
                                }
                              },
                              child: AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    if (postUrl.isNotEmpty)
                      Image.network(
                        postUrl,
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    if (isLikeAnimating)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimating: isLikeAnimating,
                          duration: const Duration(milliseconds: 200),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 120,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              // Footer section
              Row(
                children: [
                  LikeAnimation(
                    isAnimating: likes.contains(uid.toString()),
                    smallLike: true,
                    child: IconButton(
                      icon: likes.contains(uid)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () async {
                        await FirestoreMethods()
                            .likePost(postId, uid.toString(), likes);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(
                            snap: widget.snap,
                            postId: postId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Description and number of comments
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${likes.length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: uname,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' $desc',
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'View all $commentLength comments',
                          style: const TextStyle(
                            fontSize: 16,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(
                              snap: widget.snap,
                              postId: postId,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        DateFormat.yMMMd().format(datePublished.toDate()),
                        style: const TextStyle(
                          fontSize: 16,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ideal_skills/provider/user_provider.dart';
// import 'package:ideal_skills/resources/firestore_meths.dart';
// import 'package:ideal_skills/utils/colors.dart';
// import 'package:ideal_skills/utils/image_utils.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../pages/comments_page.dart';
// import 'like_animation.dart';

// class PostCard extends StatefulWidget {
//   final Map<String, dynamic> snap;

//   const PostCard({super.key, required this.snap});

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   bool isLikeAnimating = false;
//   int commentLength = 0;
//   late String postId;

//   @override
//   void initState() {
//     super.initState();
//     getComments();
//   }

//   Future<void> getComments() async {
//     try {
//       postId = widget.snap['postId'];
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(postId)
//           .collection('comments')
//           .get();

//       setState(() {
//         commentLength = snap.docs.length;
//       });
//     } catch (e) {
//       showSnackBar(e.toString(), context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserProvider>(
//       builder: (context, userProvider, child) {
//         final user = userProvider.getUser;
//         if (user == null) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         final String profile = widget.snap['profImage'] ?? '';
//         final String desc = widget.snap['description'] ?? '';
//         final String uname = widget.snap['username'] ?? '';
//         final String postUrl = widget.snap['postUrl'] ?? '';
//         final List likes = widget.snap['likes'] ?? [];
//         final Timestamp datePublished =
//             widget.snap['datePublished'] ?? Timestamp.now();
//         final String uid = user.uid;

//         return Container(
//           color: mobileBackgroundColor,
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Column(
//             children: [
//               // Header section
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
//                     .copyWith(right: 0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 16,
//                       backgroundImage: NetworkImage(profile),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               uname,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     // More options
//                   ],
//                 ),
//               ),
//               // Image section
//               GestureDetector(
//                 onDoubleTap: () {
//                   setState(() {
//                     isLikeAnimating = true;
//                   });
//                 },
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Image.network(
//                       postUrl,
//                       height: MediaQuery.of(context).size.height * 0.35,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                     if (isLikeAnimating)
//                       AnimatedOpacity(
//                         duration: const Duration(milliseconds: 200),

//                         opacity: isLikeAnimating ? 1 : 0,

//                         child: LikeAnimation(
//                           isAnimating: isLikeAnimating,
//                           duration: const Duration(milliseconds: 200),
//                           onEnd: () {
//                             setState(() {
//                               isLikeAnimating = false;
//                             });
//                           },
//                           child: const Icon(
//                             Icons.favorite,
//                             color: Colors.white,
//                             size: 120,
//                           ),
//                         ),
//                         // LikeAnimation(
//                         //   isAnimating: isLikeAnimating,
//                         //   duration: const Duration(milliseconds: 400),
//                         //   onEnd: () {
//                         //     setState(() {
//                         //       isLikeAnimating = false;
//                         //     });
//                         //   },
//                         //   child: const Icon(
//                         //     Icons.favorite,
//                         //     color: Colors.white,
//                         //     size: 100,
//                         //   ),
//                         // ),
//                       )
//                   ],
//                 ),
//               ),
//               // Footer section
//               Row(
//                 children: [
//                   LikeAnimation(
//                     isAnimating: likes.contains(uid.toString()),
//                     smallLike: true,
//                     child: IconButton(
//                       icon: likes.contains(uid)
//                           ? const Icon(Icons.favorite, color: Colors.red)
//                           : const Icon(Icons.favorite_border),
//                       onPressed: () async {
//                         await FirestoreMethods()
//                             .likePost(postId, uid.toString(), likes);
//                       },
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.comment_outlined),
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => CommentsPage(
//                             snap: widget.snap, // Add this line
//                             postId: postId, // Add this line
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               // Description and number of comments
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${likes.length} likes',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.only(top: 8),
//                       child: RichText(
//                         text: TextSpan(
//                           style: const TextStyle(color: primaryColor),
//                           children: [
//                             TextSpan(
//                               text: uname,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' ${desc}',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: Text(
//                           'View all $commentLength comments',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: secondaryColor,
//                           ),
//                         ),
//                       ),
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => CommentsPage(
//                               snap: widget.snap, // Add this line
//                               postId: postId, // Add this line
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         DateFormat.yMMMd().format(datePublished.toDate()),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: secondaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ideal_skills/provider/user_provider.dart';
// import 'package:ideal_skills/resources/firestore_meths.dart';
// import 'package:ideal_skills/utils/colors.dart';
// import 'package:ideal_skills/utils/image_utils.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../pages/comments_page.dart';
// import 'like_animation.dart';

// class PostCard extends StatefulWidget {
//   final snap;

//   const PostCard({super.key, required this.snap});

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   bool isLikeAnimating = false;
//   int commentlength = 0;
//   var post;
//   @override
//   void initState() {
//     super.initState();
//     getComments();
//   }

//   getComments() async {
//     try {
//       widget.snap.forEach((key, value) {
//         if (key.contains("postId")) {
//           post = value;
//         }
//       });
//       print("try");
//       print(widget.snap);
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(post)
//           .collection('comments')
//           .get();

//       commentlength = snap.docs.length;
//     } catch (e) {
//       showSnackBar(e.toString(), context);
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> user =
//         Provider.of<UserProvider>(context).getUser;
//     String? profile, desc, uname, post;
//     var date;
//     var uid, postId;
//     List? like;
//     user.forEach((key, value) {
//       if (key.contains("uid")) {
//         uid = value;
//       }
//     });

//     widget.snap.forEach((key, value) {
//       if (key.contains("postId")) {
//         postId = value;
//       }
//       if (key.contains("profImage")) {
//         profile = value;
//       }
//       if (key.contains("description")) {
//         desc = value;
//       }
//       if (key.contains("username")) {
//         uname = value;
//       }
//       if (key.contains("postUrl")) {
//         post = value;
//       }
//       if (key.contains("likes")) {
//         like = value;
//       }
//       if (key.contains("datePublished")) {
//         date = value;
//       }
//     });
//     print(widget.snap);
//     print(commentlength);
//     // print(snap['datePublished']);
//     // print(date);
//     return Container(
//       color: mobileBackgroundColor,
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           //header section
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
//                 .copyWith(right: 0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: NetworkImage(
//                     // snap["profImage"].toString(),
//                     profile!,
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           uname!,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       showDialog(
//                           context: context,
//                           builder: (context) => Dialog(
//                                 child: ListView(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 16),
//                                   shrinkWrap: true,
//                                   children: [
//                                     'Delete',
//                                   ]
//                                       .map(
//                                         (e) => InkWell(
//                                           onTap: () async {
//                                             FirestoreMethods()
//                                                 .deletePost(postId);
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               vertical: 12,
//                                               horizontal: 16,
//                                             ),
//                                             child: Text(e),
//                                           ),
//                                         ),
//                                       )
//                                       .toList(),
//                                 ),
//                               ));
//                     },
//                     icon: const Icon(Icons.more_vert))
//               ],
//             ),
//           ),
//           //image section

//           GestureDetector(
//             onDoubleTap: () async {
//               await FirestoreMethods().likePost(postId, uid.toString(), like!);
//               setState(() {
//                 isLikeAnimating = true;
//               });
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.45,
//                   width: double.infinity,
//                   child: Image.network(
//                     // snap['postUrl'].toString(),
//                     post!,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 200),
//                   opacity: isLikeAnimating ? 1 : 0,
//                   child: LikeAnimation(
//                     isAnimating: isLikeAnimating,
//                     duration: const Duration(milliseconds: 400),
//                     onEnd: () {
//                       setState(() {
//                         isLikeAnimating = false;
//                       });
//                     },
//                     child: const Icon(
//                       Icons.favorite,
//                       color: Colors.white,
//                       size: 120,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),

//           //likes comments section

//           Row(
//             children: [
//               LikeAnimation(
//                 isAnimating: like!.contains(uid.toString()),
//                 smallLike: true,
//                 child: IconButton(
//                   onPressed: () async {
//                     await FirestoreMethods()
//                         .likePost(postId, uid.toString(), like!);
//                   },
//                   icon: like!.contains(uid.toString())
//                       ? const Icon(
//                           Icons.favorite,
//                           color: Colors.red,
//                         )
//                       : const Icon(Icons.favorite_border),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => CommentsPage(
//                       snap: widget.snap,
//                     ),
//                   ),
//                 ),
//                 icon: const Icon(
//                   Icons.mode_comment_outlined,
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.send,
//                 ),
//               ),
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.bookmark_add_outlined,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           //Description and No.Of Comments

//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${like!.length.toString()} likes',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(
//                     top: 8,
//                   ),
//                   child: RichText(
//                     text: TextSpan(
//                       style: const TextStyle(color: primaryColor),
//                       children: [
//                         TextSpan(
//                           text: uname!,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' ${desc!}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       'View all $commentlength comments ',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: secondaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 3),
//                   child: Text(
//                     DateFormat.yMMMd().format(date.toDate()),
//                     // DateFormat.yMEd().add_jms().format(date),
//                     // date!,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: secondaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
