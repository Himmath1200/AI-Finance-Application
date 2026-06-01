import 'dart:developer' as developer;

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:ai_finance_platform/models/index.dart';

/// Firebase Authentication Service
class AuthService {
  final _auth = fb_auth.FirebaseAuth.instance;

  /// Get current user
  User? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return User(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
        profileImageUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Stream of authentication changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().map((fbUser) {
      if (fbUser != null) {
        return User(
          uid: fbUser.uid,
          email: fbUser.email ?? '',
          name: fbUser.displayName ?? 'User',
          profileImageUrl: fbUser.photoURL,
          createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
        );
      }
      return null;
    });
  }

  /// Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      return User(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      developer.log('Sign up error: ${e.message}', error: e);
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return User(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
        name: userCredential.user!.displayName ?? 'User',
        profileImageUrl: userCredential.user!.photoURL,
        createdAt: userCredential.user!.metadata.creationTime ?? DateTime.now(),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      developer.log('Sign in error: ${e.message}', error: e);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on fb_auth.FirebaseAuthException catch (e) {
      developer.log('Sign out error: ${e.message}', error: e);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb_auth.FirebaseAuthException catch (e) {
      developer.log('Password reset error: ${e.message}', error: e);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (name != null) {
          await user.updateDisplayName(name);
        }
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      developer.log('Update profile error: ${e.message}', error: e);
      rethrow;
    }
  }
}

/// Firebase Realtime Database Service
class RealtimeDatabaseService {
  final _database = FirebaseDatabase.instance.ref();

  /// Create or update user document
  Future<void> setUserData(User user) async {
    try {
      await _database.child('users').child(user.uid).set(user.toMap());
    } catch (e) {
      developer.log('Error setting user data: $e', error: e);
      rethrow;
    }
  }

  /// Get user document
  Future<User?> getUserData(String uid) async {
    try {
      final snapshot = await _database.child('users').child(uid).get();
      if (snapshot.exists) {
        return User.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } catch (e) {
      developer.log('Error getting user data: $e', error: e);
      rethrow;
    }
  }

  /// Save finance data
  Future<String> saveFinanceData(FinanceData financeData) async {
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');
      
      final docRef = _database
          .child('users')
          .child(uid)
          .child('transactions')
          .push();
      await docRef.set(financeData.toMap());
      return docRef.key ?? '';
    } catch (e) {
      developer.log('Error saving finance data: $e', error: e);
      rethrow;
    }
  }

  /// Get latest finance data for user
  Future<FinanceData?> getLatestFinanceData(String uid) async {
    try {
      final snapshot = await _database
          .child('users')
          .child(uid)
          .child('transactions')
          .limitToLast(1)
          .get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final lastEntry = data.values.first as Map;
        return FinanceData.fromMap(Map<String, dynamic>.from(lastEntry));
      }
      return null;
    } catch (e) {
      developer.log('Error getting finance data: $e', error: e);
      rethrow;
    }
  }

  /// Save AI recommendation
  Future<void> saveRecommendation(AIRecommendation recommendation) async {
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');
      
      await _database
          .child('users')
          .child(uid)
          .child('recommendations')
          .child(recommendation.id)
          .set(recommendation.toMap());
    } catch (e) {
      developer.log('Error saving recommendation: $e', error: e);
      rethrow;
    }
  }

  /// Save notification
  Future<void> saveNotification(NotificationModel notification) async {
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');
      
      await _database
          .child('users')
          .child(uid)
          .child('notifications')
          .child(notification.id)
          .set(notification.toMap());
    } catch (e) {
      developer.log('Error saving notification: $e', error: e);
      rethrow;
    }
  }

  /// Get notifications for user
  Future<List<NotificationModel>> getUserNotifications(String uid) async {
    try {
      final snapshot = await _database
          .child('users')
          .child(uid)
          .child('notifications')
          .get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data.values
            .map((v) => NotificationModel.fromMap(Map<String, dynamic>.from(v as Map)))
            .toList();
      }
      return [];
    } catch (e) {
      developer.log('Error getting notifications: $e', error: e);
      rethrow;
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');
      
      await _database
          .child('users')
          .child(uid)
          .child('notifications')
          .child(notificationId)
          .update({'isRead': true});
    } catch (e) {
      developer.log('Error marking notification as read: $e', error: e);
      rethrow;
    }
  }
}

/// Alias for backward compatibility
class FirestoreService extends RealtimeDatabaseService {}
