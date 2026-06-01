import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Firebase configuration options
/// This file should be generated using FlutterFire CLI
class DefaultFirebaseOptions {
  static const web = FirebaseOptions(
    apiKey: 'AIzaSyA1iQ7HHLc7UJWsdpyvQQa5XPWbn8xl1gw',
    appId: '1:180571091647:web:2c0b0b0b0b0b0b0b',
    messagingSenderId: '180571091647',
    projectId: 'ai-finance-platform-24808',
  );

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyA1iQ7HHLc7UJWsdpyvQQa5XPWbn8xl1gw',
    appId: '1:180571091647:android:210b83b2552c084b874c0a',
    messagingSenderId: '180571091647',
    projectId: 'ai-finance-platform-24808',
  );

  static const ios = FirebaseOptions(
    apiKey: 'AIzaSyA1iQ7HHLc7UJWsdpyvQQa5XPWbn8xl1gw',
    appId: '1:180571091647:ios:2c0b0b0b0b0b0b0b',
    messagingSenderId: '180571091647',
    projectId: 'ai-finance-platform-24808',
  );

  static const macos = FirebaseOptions(
    apiKey: 'AIzaSyA1iQ7HHLc7UJWsdpyvQQa5XPWbn8xl1gw',
    appId: '1:180571091647:macos:2c0b0b0b0b0b0b0b',
    messagingSenderId: '180571091647',
    projectId: 'ai-finance-platform-24808',
  );

  static const windows = FirebaseOptions(
    apiKey: 'AIzaSyA1iQ7HHLc7UJWsdpyvQQa5XPWbn8xl1gw',
    appId: '1:180571091647:windows:2c0b0b0b0b0b0b0b',
    messagingSenderId: '180571091647',
    projectId: 'ai-finance-platform-24808',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (Platform.operatingSystem) {
      case 'linux':
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case 'macos':
        return macos;
      case 'windows':
        return windows;
      case 'android':
        return android;
      case 'ios':
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
