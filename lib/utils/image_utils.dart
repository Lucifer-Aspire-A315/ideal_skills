// import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  throw 'No Image Selected';
}

// Future<XFile> pickVideo(ImageSource source) async {
//   final ImagePicker picker = ImagePicker();
//   final XFile? video = await picker.pickVideo(source: source);
//   if (video != null) {
//     return video;
//   } else {
//     throw Exception('Video not selected');
//   }
// }

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}




// import 'package:image_picker/image_picker.dart';

// pickImage(ImageSource source) async {
//   final ImagePicker _imagepicker = ImagePicker();
//   XFile? _file = await _imagepicker.pickImage(source: source);

//   if (_file != null) {
//     return await _file.readAsBytes();
//   }
//   print("No images selected");
// }

// showSnackBar(String content, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }
