import 'package:docu_sync/constants/theme.dart';
import 'package:docu_sync/models/error_model.dart';
import 'package:docu_sync/models/user_model.dart';
import 'package:docu_sync/repository/auth_repository.dart';
import 'package:docu_sync/router.dart';
import 'package:docu_sync/screens/home_screen.dart';
import 'package:docu_sync/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    if (error != null && error.data != null) {
      ref.read(userProvider.notifier).update((state) => error.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DocuSync',
       // ✅ Add these localization delegates
      localizationsDelegates:  [
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ Specify supported locales
      supportedLocales: const [
        Locale('en'), // English
        // Add more locales if needed (e.g., Locale('hi') for Hindi)
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
       routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}

