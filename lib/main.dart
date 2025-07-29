import 'package:docu_sync/constants/theme.dart';
import 'package:docu_sync/screens/login_screen.dart';
import 'package:docu_sync/screens/spalsh_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DocuSync',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, 
      home: SplashScreen(),
    );
  }
}

