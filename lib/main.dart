import 'package:flutter/material.dart';
import 'package:flutter_dev_test/features/authentication/presentation/pages/recovery/recovery_secret_page.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/presentation/pages/login/login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: 'sign_in',
          path: '/',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          name: 'recovery_secret',
          path: '/recovery_secret',
          builder: (context, state) => RecoverySecretPage(),
        ),
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Login UI',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: _router,
    );
  }
}
