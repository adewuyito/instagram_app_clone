import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';

extension CollectionName on FileType {
  String get collectionName {
    switch (this) {
      case FileType.image:
        return 'image';
      case FileType.video:
        return 'video';
    }
  }
}
