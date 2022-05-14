import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

const goldenTestDevices = [
  // Ios
  Device(name: 'iPhone 12 Pro Max', size: Size(428, 926)),
  Device(name: 'iPhone 12', size: Size(390, 844)),
  Device(name: 'iPhone 12 mini', size: Size(375, 812)),
  Device(name: 'iPhone 11', size: Size(414, 896)),
  Device(name: 'iPhone 8', size: Size(375, 667)),
  Device(name: 'iPhone SE', size: Size(320, 568)),
  // Android
  Device(name: 'Samsung S7', size: Size(360, 640)),
  Device(name: 'Sony Xperia L4', size: Size(360, 840)),
  Device(name: 'Samsung S20+', size: Size(384, 854)),
  Device(name: 'Xiaomi Redmi Note 8', size: Size(393, 851)),
  Device(name: 'Samsung S10 Lite', size: Size(412, 914)),
  Device(name: 'Sony Xperia Z Ultra', size: Size(540, 960)),
];

Future<void> goldenTest(
  WidgetTester tester, {
  required Widget widget,
  required String fileName,
}) async {
  await tester.pumpWidgetBuilder(
    widget,
    surfaceSize: const Size(375, 812),
  );
  await multiScreenGolden(
    tester,
    fileName,
  );
}
