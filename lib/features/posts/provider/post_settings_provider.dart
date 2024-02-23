import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/image_upload/models/post_settings_enum.dart';
import 'package:instagram_app_clone/features/posts/notifier/post_settings_notifier.dart';

final postSettingprovider = StateNotifierProvider<PostSettingsNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingsNotifier(),
);
