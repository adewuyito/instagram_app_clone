import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/data_not_found_anaimation_widget.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/empty_with_text.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/error_animation_widget.dart';
import 'package:instagram_app_clone/common/typedefs/search_term.dart';
import 'package:instagram_app_clone/features/posts/views/widgets/post_sliver_grid_view.dart';
import 'package:instagram_app_clone/features/search/provider/post_by_serach_term_provider.dart';
import 'package:instagram_app_clone/utils/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  final SearchTerm searchTearm;
  const SearchGridView({super.key, required this.searchTearm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTearm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentWithTextWidget(
          text: Strings.enterYourSearchTerm,
        ),
      );
    }

    final post = ref.watch(postBySearchTermProvider(searchTearm));

    return post.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(child: DataNotFoundAnimation());
        } else {
          return PostSliverGridView(posts: posts);
        }
      },
      error: (_, __) => const SliverToBoxAdapter(child: ErrorAnimationWidget()),
      loading: () => const SliverToBoxAdapter(child: CircularProgressIndicator()),
    );
  }
}
