import 'dart:collection';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/features/image_upload/models/post_settings_enum.dart';

class PostSettingsNotifier extends StateNotifier<Map<PostSetting, bool>> {
  PostSettingsNotifier() : super(UnmodifiableMapView({for (final setting in PostSetting.values) setting: true}));

  void setSetting(
    PostSetting setting,
    bool value,
  ) {
    // TODO: Look for better documentation on this implementation and understand the code
    final eValue = state[setting];
    if (eValue == null || eValue == value) return;
    state = Map.unmodifiable(
      Map.from(state)..[setting] = value,
    );
  }
}
