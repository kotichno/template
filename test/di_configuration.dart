import 'package:template/di/di.dart';

Future<void> configureTestDependencies() {
  return getIt.reset();
}
