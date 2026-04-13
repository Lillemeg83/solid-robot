import 'package:flutter/material.dart';
import 'package:dyredetektiv/app/router.dart';
import 'package:dyredetektiv/app/theme.dart';

class DyredetektivApp extends StatelessWidget {
  const DyredetektivApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dyredetektiv',
      debugShowCheckedModeBanner: false,
      theme: DdTheme.theme,
      routerConfig: appRouter,
    );
  }
}
