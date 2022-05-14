import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'file_comparator.dart';
import 'golden_test_utils.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      final comparator = goldenFileComparator;
      if (comparator is LocalFileComparator) {
        goldenFileComparator = FileComparator(
          comparator.basedir,
          acceptDiffForNotMacOs: 0.07,
        );
      }

      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: goldenTestDevices,
    ),
  );
}
