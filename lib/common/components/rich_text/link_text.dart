import 'package:flutter/foundation.dart' show immutable, VoidCallback;
import 'package:instagram_app_clone/common/components/rich_text/base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped;
  const LinkText({
    required super.text,
    required super.style,
    required this.onTapped,
  });
}
