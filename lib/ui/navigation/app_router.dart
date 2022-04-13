import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template/ui/feature/error/error_screen.dart';
import 'package:template/ui/feature/main/main_screen.dart';

const _mainScreenPath = '/main';

class AppRouter extends GoRouter {
  AppRouter()
      : super(
          initialLocation: _mainScreenPath,
          routes: [
            GoRoute(path: _mainScreenPath, builder: _mainScreenBuilder),
          ],
          errorBuilder: (context, state) => ErrorScreen(error: state.error),
          debugLogDiagnostics: true,
        );

  void openMainScreen() => go(_mainScreenPath);

  static Widget _mainScreenBuilder(BuildContext context, GoRouterState state) => const MainScreen();
}
