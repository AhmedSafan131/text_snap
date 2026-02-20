import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      return image?.path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      return image?.path;
    } catch (e) {
      return null;
    }
  }
}
