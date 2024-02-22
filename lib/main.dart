import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_app_clone/features/main_view/main_view.dart';
import 'package:instagram_app_clone/features/auth/riverpod/porviders/is_logged_in_provider.dart';
import 'package:instagram_app_clone/common/providers/is_loading_provider.dart';
import 'package:instagram_app_clone/common/components/loading/loading_screen.dart';
import 'package:instagram_app_clone/features/auth/views/login_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          // Display Loading screen
          ref.listen(
            isLoadingProvider,
            (_, isLoading) {
              isLoading ? LoadingScreen.instance().show(context: context) : LoadingScreen.instance().hide();
            },
          );
          final isLogged = ref.watch(isLoggedInProvider);
          return isLogged ? const MainView() : const LoginView();
        },
      ),
    );
  }
}
