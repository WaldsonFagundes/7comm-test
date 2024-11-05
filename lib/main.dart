// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:flutter_dev_test/features/authentication/presentation/pages/recovery/recovery_secret_page.dart';
import 'features/authentication/presentation/bloc/user_bloc.dart';
import 'features/authentication/presentation/pages/login/login_page.dart';
import 'home_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    BlocProvider(
      create: (_) => sl<UserBloc>(),
      child: const MyApp(),
    ),
  );
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
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final userName = extra?['userName'] as String? ?? '';
            final password = extra?['password'] as String? ?? '';
            return RecoverySecretPage(userName: userName, password: password);
          },
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
