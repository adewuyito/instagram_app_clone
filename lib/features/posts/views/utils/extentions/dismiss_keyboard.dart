import 'package:flutter/material.dart';

extension DismissKeyBoard on Widget {
  void get dismissKeyboard => FocusManager.instance.primaryFocus?.unfocus();
}
