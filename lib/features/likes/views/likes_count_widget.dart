import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
import 'package:instagram_app_clone/common/typedefs/post_id_typedef.dart';
import 'package:instagram_app_clone/features/likes/provider/post_likes_count_provider.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/strings.dart';

class LikesCountViews extends ConsumerWidget {
  final PostId postId;
  const LikesCountViews({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));
    return likesCount.when(
      data: (likes) {
        final peopleOrPerson = likes == 1 ?  Strings.person : Strings.people;
      
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: likes.toString()),
              TextSpan(text: ' $peopleOrPerson'),
              const TextSpan(text: ' ${Strings.likedThis}')
            ],
          ),
        );
      },
      error: (_, __) => const SmallErrorAnimationWidget(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
