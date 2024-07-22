import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ideal_skills/models/user.dart' as model;
import 'package:ideal_skills/provider/user_provider.dart';
import 'package:ideal_skills/resources/firestore_meths.dart';
import 'package:ideal_skills/utils/colors.dart';
import 'package:ideal_skills/utils/image_utils.dart';
import 'package:ideal_skills/utils/video_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  XFile? _videoFile;
  VideoPlayerController? _videoController;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool isVideo = false;

  void postMedia(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = isVideo
          ? await FirestoreMethods().uploadVideo(
              _descriptionController.text,
              _videoFile!,
              uid,
              username,
              profImage,
            )
          : await FirestoreMethods().uploadPost(
              _descriptionController.text,
              _file!,
              uid,
              username,
              profImage,
              isVideo: false,
            );

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearMedia();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  _selectMedia(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                  isVideo = false;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                  isVideo = false;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Record a video'),
              onPressed: () async {
                Navigator.pop(context);
                XFile videoFile = await pickVideo(ImageSource.camera);
                setState(() {
                  _videoFile = videoFile;
                  _videoController =
                      VideoPlayerController.file(File(videoFile.path))
                        ..initialize().then((_) {
                          setState(() {
                            videoFile = _videoFile!;
                          });
                        });
                  isVideo = true;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose video from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                XFile videoFile = await pickVideo(ImageSource.gallery);
                setState(() {
                  _videoFile = videoFile;
                  _videoController =
                      VideoPlayerController.file(File(_videoFile!.path))
                        ..initialize().then((_) {
                          setState(() {
                            videoFile = _videoFile!;
                          });
                        });
                  isVideo = true;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void clearMedia() {
    setState(() {
      _file = null;
      _videoFile = null;
      _videoController = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return _file == null && _videoFile == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectMedia(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearMedia,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      postMedia(user!.uid, user.username, user.photoUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user!.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    isVideo && _videoController != null
                        ? SizedBox(
                            height: 45,
                            width: 45,
                            child: AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                          )
                        : SizedBox(
                            height: 45,
                            width: 45,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}






// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:ideal_skills/resources/firestore_meths.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// import '../provider/user_provider.dart';
// import '../utils/colors.dart';
// import '../utils/image_utils.dart';

// class AddPost extends StatefulWidget {
//   const AddPost({super.key});

//   @override
//   State<AddPost> createState() => _AddPostState();
// }

// class _AddPostState extends State<AddPost> {
//   Uint8List? _file;
//   final TextEditingController _descriptionController = TextEditingController();
//   bool isLoading = false;

//   postImage(String uid, String username, String profImage) async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       String res = await FirestoreMeths().uploadPost(
//           _descriptionController.text, _file!, uid, username, profImage);

//       if (res == "success") {
//         setState(() {
//           isLoading = false;
//         });
//         showSnackBar("Posted!!", context);
//         clearImage();
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showSnackBar(res, context);
//       }
//     } catch (e) {
//       showSnackBar(e.toString(), context);
//     }
//   }

//   _selectImage(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return SimpleDialog(
//             title: const Text("Create a Post"),
//             children: [
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text("Take a Photo"),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   Uint8List file = await pickImage(ImageSource.camera);
//                   setState(() {
//                     _file = file;
//                   });
//                 },
//               ),
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text("Choose From Gallery"),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   Uint8List file = await pickImage(ImageSource.gallery);
//                   setState(() {
//                     _file = file;
//                   });
//                 },
//               ),
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text("Cancel"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   void clearImage() {
//     setState(() {
//       _file = null;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final User user = Provider.of<UserProvider>(context).getUser;
//     final Map<String, dynamic> user =
//         Provider.of<UserProvider>(context).getUser;
//     String? p, u, n;
//     user.forEach((key, value) {
//       if (key.contains("photoUrl")) {
//         p = value;
//       }
//       if (key.contains("uid")) {
//         u = value;
//       }
//       if (key.contains("username")) {
//         n = value;
//       }
//     });
//     print(user);
//     print(p);
//     // print("${user.photoUrl}dp");
//     // final UserProvider userp = Provider.of<UserProvider>(context);
//     return _file == null
//         ? Center(
//             child: IconButton(
//                 onPressed: () => _selectImage(context),
//                 icon: Icon(Icons.upload_outlined)),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: mobileBackgroundColor,
//               leading: IconButton(
//                   onPressed: clearImage,
//                   icon: Icon(Icons.arrow_back_ios_rounded)),
//               title: const Text("Post To"),
//               actions: [
//                 TextButton(
//                   onPressed: () => postImage(u!, n!, p!),
//                   // onPressed: () =>
//                   //     postImage(user.uid, user.username, user.photoUrl),
//                   child: const Text(
//                     "Post",
//                     style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//             body: Column(
//               children: [
//                 isLoading
//                     ? const LinearProgressIndicator()
//                     : const Padding(
//                         padding: EdgeInsets.only(top: 0),
//                       ),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(p!),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.5,
//                       child: TextField(
//                         controller: _descriptionController,
//                         decoration: const InputDecoration(
//                           hintText: "Write a Caption...",
//                           border: InputBorder.none,
//                         ),
//                         maxLines: 8,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 45,
//                       width: 45,
//                       child: AspectRatio(
//                         aspectRatio: 487 / 451,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: MemoryImage(_file!),
//                                 // image: NetworkImage(user.photoUrl),
//                                 fit: BoxFit.fill,
//                                 alignment: FractionalOffset.topCenter),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // const Divider(),
//                   ],
//                 ),
//                 // Image.network(p!)
//               ],
//             ),
//           );
//   }
// }
