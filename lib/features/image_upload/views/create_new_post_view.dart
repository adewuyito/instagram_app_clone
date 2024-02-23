import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/thumbnail/file_thumbnail_veiw.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/user_id_provider.dart';
import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';
import 'package:instagram_app_clone/features/image_upload/models/post_settings_enum.dart';
import 'package:instagram_app_clone/features/image_upload/models/thumbnail_request.dart';
import 'package:instagram_app_clone/features/image_upload/provider/image_upload_provider.dart';
import 'package:instagram_app_clone/features/posts/provider/post_settings_provider.dart';
import 'package:instagram_app_clone/utils/constants/strings.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File file;
  final FileType fileType;

  const CreateNewPostView({
    super.key,
    required this.file,
    required this.fileType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    // TODO: Understand this code
    final thumbNailRequest = ThumbNailRequest(file: widget.file, fileType: widget.fileType);
    final watchedPostSettings = ref.watch(postSettingprovider);
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);
    useEffect(() {
      void listener() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listener);

      // Done this way because the return of a useeffect is always a function
      // works like the onDispose function
      // while litening to postController
      return () {
        postController.removeListener(listener);
      };
    }, [postController]);
    return Scaffold(
      appBar: AppBar(
        title: Strings.createNewPost.toText,
        actions: [
          IconButton(
            onPressed: !isPostButtonEnabled.value
                ? null
                : () async {
                    final userId = ref.watch(userIdProvider);
                    if (userId == null) return;
                    final isUploaded = await ref
                        .read(
                          imageUploadProvider.notifier,
                        )
                        .upload(
                          file: widget.file,
                          fileType: widget.fileType,
                          message: postController.text,
                          postSettings: watchedPostSettings,
                          userId: userId,
                        );
                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            FileThumbnailView(thumbNailRequest: thumbNailRequest),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(hintText: Strings.pleaseWriteYourMessageHere),
                autofocus: true,
                maxLines: null,
                controller: postController,
              ),
            ),
            ...PostSetting.values.map(
              (postSetting) => ListTile(
                title: postSetting.title.toText,
                subtitle: postSetting.description.toText,
                trailing: Switch(
                  value: watchedPostSettings[postSetting] ?? false,
                  onChanged: (isOn) {
                    ref.read(postSettingprovider.notifier).setSetting(postSetting, isOn);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ToTextWidget on String {
  Widget get toText => Text(this);
}
