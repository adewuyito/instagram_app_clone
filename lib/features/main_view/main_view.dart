// import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/dialog/model/alert_dialog.dart';
import 'package:instagram_app_clone/common/components/dialog/view/log_out_dialog.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/auth_state_provider.dart';
import 'package:instagram_app_clone/features/image_upload/models/file_types_enum.dart';
import 'package:instagram_app_clone/features/image_upload/views/create_new_post_view.dart';
import 'package:instagram_app_clone/features/posts/provider/post_settings_provider.dart';
import 'package:instagram_app_clone/features/posts/views/user_posts/all_post_view.dart';
import 'package:instagram_app_clone/features/posts/views/user_posts/user_post_view.dart';
import 'package:instagram_app_clone/features/search/view/search_view.dart';
import 'package:instagram_app_clone/features/posts/views/utils/constants/strings.dart';
import 'package:instagram_app_clone/features/posts/views/utils/helpers/image_picker.dart';

// extension Log on Object {
//   void log() => devtools.log(toString());
// }

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                // Pick A Video
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallary();
                if (videoFile == null) return;
                // ignore: unused_result
                ref.refresh(postSettingprovider);

                if (!mounted) {
                  return;
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      file: videoFile,
                      fileType: FileType.video,
                    ),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.film),
            ),
            IconButton(
              onPressed: () async {
                // Pick A Image
                final imageFile =
                    await ImagePickerHelper.pickImageFromGallary();
                if (imageFile == null) return;
                ref.invalidate(postSettingprovider);

                if (!mounted) {
                  return;
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      file: imageFile,
                      fileType: FileType.image,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogOut = await LogOutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if (shouldLogOut) {
                  ref.read(authStateProvider.notifier).logOut();
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            UserPostView(),
            SearchView(),
            AllPostView(),
          ],
        ),
      ),
    );
  }
}
