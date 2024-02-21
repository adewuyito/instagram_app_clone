import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/state/auth/riverpod/porviders/auth_state_provider.dart';
import 'package:instagram_app_clone/utils/constants/app_colors.dart';
import 'package:instagram_app_clone/utils/constants/strings.dart';
import 'package:instagram_app_clone/views/login/widget/button_widget.dart';
import 'package:instagram_app_clone/views/login/widget/divider_widget.dart';
import 'package:instagram_app_clone/views/login/widget/login_view_signup_links.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(Strings.welcomeToAppName, style: Theme.of(context).textTheme.displaySmall),
              const LoginDividerWidget(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).loginWithFaceBook();
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                child: const LoginButton(
                  icon: FontAwesomeIcons.facebook,
                  text: Strings.facebook,
                  color: AppColors.facebookColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).loginWithGoogle();
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                child: const LoginButton(
                  icon: FontAwesomeIcons.google,
                  text: Strings.google,
                  color: AppColors.googleColor,
                ),
              ),
              const LoginDividerWidget(),
              const LoginViewSignupLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
