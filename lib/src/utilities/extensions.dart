

import 'package:flutter/material.dart';

extension ContextOn on BuildContext {
  TextTheme get getTextTheme => Theme.of(this).textTheme;
}