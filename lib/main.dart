import 'package:flutter/material.dart';
import 'package:template/di/di.dart';
import 'package:template/ui/widget/app.dart';

void main() {
  configureDependencies();
  runApp(App());
}
