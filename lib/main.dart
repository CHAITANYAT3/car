import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/shared/dashboard_screen.dart';

void main() {
  final repository = AppRepository(AppDatabase.instance);
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(repository)),
        ChangeNotifierProvider(
          create: (_) => AppProvider(repository)..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Car Showroom',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          DashboardScreen.routeName: (_) => const DashboardScreen(),
        },
      ),
    );
  }
}
