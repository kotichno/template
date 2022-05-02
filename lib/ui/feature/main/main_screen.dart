import 'package:flutter/material.dart';
import 'package:template/l10n/generated/l10n.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          S.of(context).mainScreenTitle,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
