import 'package:instagram_app_clone/features/comments/models/comment_model.dart';
import 'package:instagram_app_clone/features/posts/models/post_comments_request.dart';
import 'package:instagram_app_clone/features/posts/views/utils/enums/date_sorting.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDoc = toList()
        ..sort((a, b) {
          switch (request.dateSorting) {
            case DateSorting.newestOnTop:
              return b.createdAt.compareTo(a.createdAt);
            case DateSorting.oldestOnTop:
              return a.createdAt.compareTo(b.createdAt);
          }
        });
      return sortedDoc;
    } else {
      return this;
    }
  }
}
