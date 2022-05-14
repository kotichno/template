import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
// ignore: deprecated_member_use
import 'package:test_api/test_api.dart' as test_package show TestFailure;

class FileComparator extends GoldenFileComparator with LocalComparisonOutput {
  /// The directory in which the test was loaded.
  ///
  /// Golden file keys will be interpreted as file paths relative to this
  /// directory.
  final Uri basedir;

  final double acceptDiffForNotMacOs;

  /// Path context exists as an instance variable rather than just using the
  /// system path context in order to support testing, where we can spoof the
  /// platform to test behaviors with arbitrary path styles.
  final path.Context _path;

  FileComparator(
    this.basedir, {
    required this.acceptDiffForNotMacOs,
    path.Style? pathStyle,
  }) : _path = _getPath(pathStyle);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    final bool isTestPassed;
    if (!Platform.isMacOS) {
      isTestPassed = result.passed || result.diffPercent <= acceptDiffForNotMacOs;
    } else {
      isTestPassed = result.passed;
    }

    if (!isTestPassed) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return isTestPassed;
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {
    final goldenFile = _getGoldenFile(golden);
    await goldenFile.parent.create(recursive: true);
    await goldenFile.writeAsBytes(imageBytes, flush: true);
  }

  /// Returns the bytes of the given [golden] file.
  ///
  /// If the file cannot be found, an error will be thrown.
  @protected
  Future<List<int>> getGoldenBytes(Uri golden) async {
    final goldenFile = _getGoldenFile(golden);
    if (!goldenFile.existsSync()) {
      // ignore: only_throw_errors
      throw test_package.TestFailure('Could not be compared against non-existent file: "$golden"');
    }
    final List<int> goldenBytes = await goldenFile.readAsBytes();
    return goldenBytes;
  }

  static path.Context _getPath(path.Style? style) {
    return path.Context(style: style ?? path.Style.platform);
  }

  File _getGoldenFile(Uri golden) =>
      File(_path.join(_path.fromUri(basedir), _path.fromUri(golden.path)));
}

/// A mixin for use in golden file comparators that run locally and provide
/// output.
mixin LocalComparisonOutput {
  /// Writes out diffs from the [ComparisonResult] of a golden file test.
  ///
  /// Will throw an error if a null result is provided.
  Future<String> generateFailureOutput(
    ComparisonResult result,
    Uri golden,
    Uri basedir, {
    String key = '',
  }) async =>
      TestAsyncUtils.guard<String>(() async {
        var additionalFeedback = '';
        if (result.diffs != null) {
          additionalFeedback =
              '\nFailure feedback can be found at ${path.join(basedir.path, 'failures')}';
          final diffs = result.diffs!.cast<String, Image>();
          for (final entry in diffs.entries) {
            final output = getFailureFile(
              key.isEmpty ? entry.key : '${entry.key}_$key',
              golden,
              basedir,
            );
            output.parent.createSync(recursive: true);
            final pngBytes = await entry.value.toByteData(format: ImageByteFormat.png);
            output.writeAsBytesSync(pngBytes!.buffer.asUint8List());
          }
        }
        return 'Golden "$golden": ${result.error}$additionalFeedback';
      });

  /// Returns the appropriate file for a given diff from a [ComparisonResult].
  File getFailureFile(String failure, Uri golden, Uri basedir) {
    final fileName = golden.pathSegments.last;
    final testName = '${fileName.split(path.extension(fileName))[0]}_$failure.png';
    return File(path.join(
      path.fromUri(basedir),
      path.fromUri(Uri.parse('failures/$testName')),
    ));
  }
}
