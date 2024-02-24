import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/common/typedefs/user_id_typedef.dart';

@immutable
class LikeDislikeRequest {
  final PostId postId;
  final UserId userLikedBy;

  const LikeDislikeRequest({
    required this.postId,
    required this.userLikedBy,
  });
}
