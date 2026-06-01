import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ai_finance_platform/models/index.dart';
import 'package:ai_finance_platform/services/firebase_service.dart';

/// Firebase Cloud Messaging Notification Service
class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _firestoreService = FirestoreService();

  /// Initialize notifications
  Future<void> initializeNotifications(String uid) async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      developer.log('User notification settings: ${settings.authorizationStatus}');

      // Get FCM token
      final token = await _messaging.getToken();
      developer.log('FCM Token: $token');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        developer.log('Received message in foreground: ${message.notification?.title}');
        _handleMessage(message, uid);
      });

      // Handle background messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        developer.log('Opened from background: ${message.notification?.title}');
        _handleMessage(message, uid);
      });
    } catch (e) {
      developer.log('Error initializing notifications: $e', error: e);
    }
  }

  /// Handle incoming message
  void _handleMessage(RemoteMessage message, String uid) {
    final notification = NotificationModel(
      id: message.messageId ?? '',
      uid: uid,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      type: message.data['type'] ?? 'default',
      createdAt: DateTime.now(),
    );

    _firestoreService.saveNotification(notification);
  }

  /// Send budget exceeded notification
  Future<void> sendBudgetExceededAlert({
    required String uid,
    required double currentExpenses,
    required double budget,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: uid,
        title: '⚠️ Budget Alert',
        body:
            'Your current spending (₹${currentExpenses.toStringAsFixed(2)}) exceeds your budget of ₹${budget.toStringAsFixed(2)}',
        type: 'budget_alert',
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveNotification(notification);
    } catch (e) {
      developer.log('Error sending budget alert: $e', error: e);
    }
  }

  /// Send goal reminder notification
  Future<void> sendGoalReminder({
    required String uid,
    required double goalAmount,
    required int monthsRemaining,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: uid,
        title: '💰 Goal Reminder',
        body:
            'You have $monthsRemaining months to save ₹${goalAmount.toStringAsFixed(2)} for your goal!',
        type: 'goal_reminder',
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveNotification(notification);
    } catch (e) {
      developer.log('Error sending goal reminder: $e', error: e);
    }
  }

  /// Send monthly finance check-in notification
  Future<void> sendMonthlyCheckIn({
    required String uid,
    required double income,
    required double expenses,
    required double savings,
  }) async {
    try {
      final savingsRatio = (savings / income * 100).toStringAsFixed(1);

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: uid,
        title: '📊 Monthly Finance Summary',
        body:
            'Income: ₹${income.toStringAsFixed(2)} | Expenses: ₹${expenses.toStringAsFixed(2)} | Savings: $savingsRatio%',
        type: 'monthly_reminder',
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveNotification(notification);
    } catch (e) {
      developer.log('Error sending monthly check-in: $e', error: e);
    }
  }

  /// Send investment opportunity notification
  Future<void> sendInvestmentOpportunity({
    required String uid,
    required String investmentType,
    required String description,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: uid,
        title: '📈 Investment Opportunity',
        body: '$investmentType: $description',
        type: 'investment_alert',
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveNotification(notification);
    } catch (e) {
      developer.log('Error sending investment opportunity: $e', error: e);
    }
  }
}
