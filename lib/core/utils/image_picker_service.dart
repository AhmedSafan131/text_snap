import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    return image?.path;
  }
}
