import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/typedefs/is_loading_typedef.dart';
import 'package:instagram_app_clone/features/image_upload/notifier/image_upload_notifier.dart';

final imageUploadProvider = StateNotifierProvider<ImageUploadNotifier, IsLoading>((ref) => ImageUploadNotifier());