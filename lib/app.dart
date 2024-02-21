import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/state/auth/backends/authenticator.dart';
import 'package:instagram_app_clone/state/auth/riverpod/porviders/auth_state_provider.dart';
import 'package:instagram_app_clone/views/components/loading/loading_screen.dart';
import 'package:riverpod/riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Instagram App Clone'),
          actions: [
            IconButton(
              onPressed: () async {
                ref.read(authStateProvider.notifier).logOut();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: const Center(
          child: Text('Welcome to Instagram App Clone'),
        ),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
      ),
      body: Consumer(
        builder: (context, ref, child) => Column(children: [
          ElevatedButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).loginWithFaceBook();
            },
            child: const Text('Login with facebook'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).loginWithGoogle();
            },
            child: const Text('Login with Google'),
          ),
        ]),
      ),
    );
  }
}
