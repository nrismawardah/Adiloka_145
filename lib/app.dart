import 'package:adiloka/presentation/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adiloka/logic/blocs/auth/auth_bloc.dart';
import 'package:adiloka/data/repository/auth_repository.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/landing_page.dart';
// import halaman lain seperti home_page.dart atau admin_page.dart

class AdilokaApp extends StatelessWidget {
  const AdilokaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(repository: AuthRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adiloka',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: const Color(0xFF5C4033),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          //'/home': (context) =>
          //const Placeholder(), // Ganti nanti dengan HomePage()
          //'/admin': (context) =>
          //const Placeholder(), // Ganti nanti dengan AdminPage()
        },
      ),
    );
  }
}
