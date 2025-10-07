import 'package:docu_sync/screens/home_screen.dart';
import 'package:docu_sync/screens/login_screen.dart';
import 'package:docu_sync/screens/splash_screen.dart';
import 'package:docu_sync/screens/document_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: SplashScreen()),
  '/login': (route) => const MaterialPage(child: LoginScreen()),
  '/home': (route) => const MaterialPage(child: HomeScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: SplashScreen()),
  '/home': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),
});
