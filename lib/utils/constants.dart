/// App constants
class AppConstants {
  // App info
  static const String appName = 'AI Finance Platform';
  static const String appVersion = '1.0.0';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String financeDataCollection = 'finance_data';
  static const String recommendationsCollection = 'recommendations';
  static const String notificationsCollection = 'notifications';
  static const String investmentHistoryCollection = 'investment_history';

  // Route names
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String dashboardRoute = '/dashboard';
  static const String financeFormRoute = '/finance-form';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String recommendationsRoute = '/recommendations';
  static const String notificationsRoute = '/notifications';

  // Colors
  static const int primaryColor = 0xFF6366F1;
  static const int secondaryColor = 0xFF06B6D4;
  static const int successColor = 0xFF10B981;
  static const int errorColor = 0xFFEF4444;
  static const int warningColor = 0xFFF59E0B;

  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration loadingTimeout = Duration(seconds: 30);

  // Sizes
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;

  // Investment types
  static const String investmentTypeStocks = 'Stocks';
  static const String investmentTypeMutualFunds = 'Mutual Funds';
  static const String investmentTypeBonds = 'Bonds';
  static const String investmentTypeFD = 'Fixed Deposits';
  static const String investmentTypeSIP = 'SIP';

  // Risk levels
  static const String riskLevelLow = 'Low';
  static const String riskLevelMedium = 'Medium';
  static const String riskLevelHigh = 'High';

  // Notification types
  static const String notificationTypeBudgetAlert = 'budget_alert';
  static const String notificationTypeGoalReminder = 'goal_reminder';
  static const String notificationTypeMonthlyReminder = 'monthly_reminder';
  static const String notificationTypeInvestmentAlert = 'investment_alert';
}
