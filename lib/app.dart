import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_app_clone/common/components/animations/widgets/empty_animation.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => EmptyAnimationWidget(),
    );
  }
}
