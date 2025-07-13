import 'package:adiloka/data/models/response/user_response.dart';
import 'package:adiloka/presentation/auth/register_page.dart';
import 'package:adiloka/presentation/user/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adiloka/logic/blocs/auth/auth_bloc.dart';
import 'package:adiloka/data/repository/auth_repository.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/landing_page.dart';
import 'package:adiloka/logic/blocs/karya/karya_bloc.dart';
import 'package:adiloka/data/repository/karya_repository.dart';

class AdilokaApp extends StatelessWidget {
  const AdilokaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(repository: AuthRepository())),
        BlocProvider(create: (_) => KaryaBloc(repository: KaryaRepository())),
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
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const LandingPage());
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case '/home':
              final user = settings.arguments as UserModel;
              return MaterialPageRoute(builder: (_) => HomePage(user: user));

            // case '/admin':
            //   final user = settings.arguments as User;
            //   return MaterialPageRoute(builder: (_) => AdminPage(user: user));
            default:
              return null;
          }
        },
      ),
    );
  }
}
