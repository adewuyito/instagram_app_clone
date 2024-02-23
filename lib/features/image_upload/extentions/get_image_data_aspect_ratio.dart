import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:instagram_app_clone/features/image_upload/extentions/get_image_aspect_ratio.dart';

extension GetImageDataAspectRatio on Uint8List {
  Future<double> get getAspectRatio {
    final image = Image.memory(this);
    return image.getAspectRatio;
  }
}
