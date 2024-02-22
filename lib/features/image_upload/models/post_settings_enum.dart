import 'package:instagram_app_clone/utils/constants/post_constants.dart';

enum PostSetting  {
  allowLikes(
    title: PostConstants.allowLikesTitle,
    description: PostConstants.allowLikesDescription,
    storageKey: PostConstants.allowLikesStorageKey,
  ),
  allowComments(
    title: PostConstants.allowCommentsTitle,
    description: PostConstants.allowCommentsDescription,
    storageKey: PostConstants.allowCommentsStorageKey,
  );

  final String title;
  final String description;
  final String storageKey;

  const PostSetting({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}


/// Extension on [PostSettings] to get the title, description and storage key
extension PostSettingsX on PostSetting {
  String get title => 'title';
  String get description => 'description';
  String get storageKey => 'storageKey';
}