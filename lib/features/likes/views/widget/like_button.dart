import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/features/likes/models/like_dislke_request.dart';
import 'package:instagram_app_clone/features/likes/provider/has_liked_post_provider.dart';
import 'package:instagram_app_clone/features/likes/provider/like_dislike_post_provider.dart';


/// Button to like a post and update the database for the like request
class LikeBottun extends ConsumerWidget {
  final PostId postId;
  const LikeBottun({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(hasLikedPostProvider(postId));
    
    return isLiked.when(
      data: (liked) {
        return IconButton(
          onPressed: () {
            final userId = ref.read(userIdProvider);
            if (userId == null) {
              return;
            }
            // Building the like request for the provider
            final likeRequest = LikeDislikeRequest(postId: postId, userLikedBy: userId);
            ref.read(likeDislikeProvider(likeRequest));
          },
          icon: liked ? const FaIcon(FontAwesomeIcons.solidHeart) : const FaIcon(FontAwesomeIcons.heart)
        );
      },
      error: (_, __) => const SmallErrorAnimationWidget(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
