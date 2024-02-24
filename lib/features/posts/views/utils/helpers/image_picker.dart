import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app_clone/features/image_upload/extentions/to_file.dart';

@immutable
class ImagePickerHelper {
  static final _imagePicker = ImagePicker();

  static Future<File?> pickImageFromGallary() => _imagePicker.pickImage(source: ImageSource.gallery).toFile;
  static Future<File?> pickVideoFromGallary() => _imagePicker.pickVideo(source: ImageSource.gallery).toFile;
}
