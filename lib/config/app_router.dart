/// App configuration and routes
import 'package:flutter/material.dart';
import 'package:ai_finance_platform/screens/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// App router configuration
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppConstants.loginRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case AppConstants.signupRoute:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );

      case AppConstants.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );

      case AppConstants.dashboardRoute:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case AppConstants.financeFormRoute:
        return MaterialPageRoute(
          builder: (_) => const FinanceFormScreen(),
        );

      case AppConstants.profileRoute:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case AppConstants.settingsRoute:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
