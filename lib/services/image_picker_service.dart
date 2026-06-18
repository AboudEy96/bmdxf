import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<Uint8List?> pickFromGallery();
  Future<Uint8List?> pickFromCamera();
}

class ImagePickerServiceImpl implements ImagePickerService {
  ImagePickerServiceImpl._();
  static final ImagePickerService instance = ImagePickerServiceImpl._();

  final ImagePicker _picker = ImagePicker();

  @override
  Future<Uint8List?> pickFromGallery() =>
      _pick(ImageSource.gallery);

  @override
  Future<Uint8List?> pickFromCamera() =>
      _pick(ImageSource.camera);

  Future<Uint8List?> _pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    return file?.readAsBytes();
  }
}
