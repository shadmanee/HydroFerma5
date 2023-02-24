import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final mobileScaffold, tabScaffold, desktopScaffold;
  ResponsiveLayout(
      {Key? key,
        required this.mobileScaffold,
        required this.tabScaffold,
        required this.desktopScaffold})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 413) {
        return mobileScaffold;
      } else if (constraints.maxWidth < 1100) {
        return tabScaffold;
      } else {
        return desktopScaffold;
      }
    });
  }
}
