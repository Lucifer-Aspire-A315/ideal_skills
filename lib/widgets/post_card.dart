import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ideal_skills/provider/user_provider.dart';
import 'package:ideal_skills/resources/firestore_meths.dart';
import 'package:ideal_skills/utils/colors.dart';
import 'package:ideal_skills/utils/image_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../pages/comments_page.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlength = 0;
  var post;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  getComments() async {
    try {
      widget.snap.forEach((key, value) {
        if (key.contains("postId")) {
          post = value;
        }
      });
      print("try");
      print(widget.snap);
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(post)
          .collection('comments')
          .get();

      commentlength = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user =
        Provider.of<UserProvider>(context).getUser;
    String? profile, desc, uname, post;
    var date;
    var uid, postId;
    List? like;
    user.forEach((key, value) {
      if (key.contains("uid")) {
        uid = value;
      }
    });

    widget.snap.forEach((key, value) {
      if (key.contains("postId")) {
        postId = value;
      }
      if (key.contains("profImage")) {
        profile = value;
      }
      if (key.contains("description")) {
        desc = value;
      }
      if (key.contains("username")) {
        uname = value;
      }
      if (key.contains("postUrl")) {
        post = value;
      }
      if (key.contains("likes")) {
        like = value;
      }
      if (key.contains("datePublished")) {
        date = value;
      }
    });
    print(widget.snap);
    print(commentlength);
    // print(snap['datePublished']);
    // print(date);
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //header section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    // snap["profImage"].toString(),
                    profile!,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uname!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map(
                                        (e) => InkWell(
                                          onTap: () async {
                                            FirestoreMeths().deletePost(postId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          //image section

          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMeths().likePost(postId, uid.toString(), like!);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Image.network(
                    // snap['postUrl'].toString(),
                    post!,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          //likes comments section

          Row(
            children: [
              LikeAnimation(
                isAnimating: like!.contains(uid.toString()),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMeths()
                        .likePost(postId, uid.toString(), like!);
                  },
                  icon: like!.contains(uid.toString())
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.mode_comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_add_outlined,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //Description and No.Of Comments

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${like!.length.toString()} likes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: uname!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${desc!}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentlength comments ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    DateFormat.yMMMd().format(date.toDate()),
                    // DateFormat.yMEd().add_jms().format(date),
                    // date!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
