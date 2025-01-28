import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressedImage = await _compressImage(File(pickedFile.path));
      return compressedImage;
    }
    return null;
  }

  static Future<File?> pickImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final compressedImage = await _compressImage(File(pickedFile.path));
      return compressedImage;
    }
    return null;
  }

  static Future<File?> _compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = join(tempDir.path, '${basename(file.path)}_compressed.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 100,
      minWidth: 800,  // Set desired minimum width
      minHeight: 800,// Set the quality level (0-100)
    );

    return result != null ? File(result.path) : null; // Return a File or null if compression fails
  }
}
