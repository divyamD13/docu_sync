import 'package:docu_sync/constants/theme.dart';
import 'package:docu_sync/models/error_model.dart';
import 'package:docu_sync/models/user_model.dart';
import 'package:docu_sync/repository/auth_repository.dart';
import 'package:docu_sync/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();

}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
@override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async{
    ErrorModel error = await ref.read(authRepositoryProvider).getUserData();
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

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

