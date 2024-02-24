import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/error_animation_widget.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/loading_animation_widget.dart';
import 'package:instagram_app_clone/features/posts/models/post.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends HookWidget {
  final Post post;
  const PostVideoView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.networkUrl(post.fileUrl as Uri);

    final isVideoPlayerReady = useState(false);

    useEffect(() {
      controller.initialize().then(
        (value) {
          isVideoPlayerReady.value = true;
          controller.setLooping(true);
          controller.play();
        },
      );
      return controller.dispose;
    }, [controller]);

    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(
            controller,
          ),
        );
      case false:
        return const LoadingAnimationWidget();
      default:
        return const ErrorAnimationWidget();
    }
  }
}
