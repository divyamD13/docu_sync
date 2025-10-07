import 'dart:async';
import 'package:docu_sync/models/user_model.dart';
import 'package:docu_sync/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      final user = ref.read(userProvider);
      if (user != null && user.token.isNotEmpty) {
        Routemaster.of(context).replace('/home');
      } else {
        Routemaster.of(context).replace('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 121, 107, 1),
            Color.fromRGBO(73, 169, 158, 1),
            Color.fromRGBO(255, 255, 255, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SvgPicture.asset(
            'assets/images/docusync_logo.svg',
            height: 200,
            width: 200,
            semanticsLabel: 'DocuSync',
          ),
        ),
      ),
    );
  }
}
