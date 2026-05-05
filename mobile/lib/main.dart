import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/explore/presentation/provider/explore_provider.dart';
import 'features/explore/presentation/screens/explore_screen.dart';
import 'features/main/presentation/screens/main_screen.dart';
import 'features/details/presentation/provider/detail_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()..fetchExploreData()),
        ChangeNotifierProvider(create: (_) => DetailProvider()),
      ],
      child: const Fellow4UApp(),
    ),
  );
}

class Fellow4UApp extends StatefulWidget {
  const Fellow4UApp({super.key});

  @override
  State<Fellow4UApp> createState() => _Fellow4UAppState();
}

class _Fellow4UAppState extends State<Fellow4UApp> {
  @override
  void initState() {
    super.initState();
    // Thử tự động đăng nhập khi mở app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fellow4U',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/', // Reverted to Onboarding for proper flow
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/explore': (context) => const MainScreen(),
      },
    );
  }
}
