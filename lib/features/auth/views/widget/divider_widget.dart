import 'package:flutter/material.dart';

class LoginDividerWidget extends StatelessWidget {
  const LoginDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 40),
        Divider(),
        SizedBox(height: 40),
      ],
    );
  }
}
