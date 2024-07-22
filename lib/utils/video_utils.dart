import 'package:image_picker/image_picker.dart';

Future<XFile> pickVideo(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? video = await picker.pickVideo(source: source);
  if (video != null) {
    return video;
  } else {
    throw Exception('Video not selected');
  }
}
