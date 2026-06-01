import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/config/app_router.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/services/index.dart';
import 'package:ai_finance_platform/screens/index.dart';
import 'package:ai_finance_platform/utils/index.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (no .env loading on web)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Finance Provider
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: ThemeProvider.getLightTheme(),
            darkTheme: ThemeProvider.getDarkTheme(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppConstants.splashRoute,
          );
        },
      ),
    );
  }
}
