import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'config/theme.dart';

void main() {
  runApp(const DrinkYourWinePOS());
}

class DrinkYourWinePOS extends StatelessWidget {
  const DrinkYourWinePOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drink Your Wine POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
