import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:ai_finance_platform/services/firebase_service.dart';
import 'package:ai_finance_platform/models/user_model.dart';
import 'dart:developer' as developer;

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  User? get user => _user;
  User? get currentUser => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  /// Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      
      developer.log('Sign up successful: ${_user?.email}');
      _isLoading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Sign up failed';
      developer.log('Sign up error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Unexpected error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign Up Test (for Phase 1)
  Future<void> signUpTest(String email, String password, String name) async {
    await signUp(email: email, password: password, name: name);
  }

  /// Sign In
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.signIn(
        email: email,
        password: password,
      );

      developer.log('Login successful: ${_user?.email}');
      _isLoading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed';
      developer.log('Login error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Unexpected error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign In Test (for Phase 1)
  Future<void> loginTest(String email, String password) async {
    await signIn(email: email, password: password);
  }

  /// Sign Out
  Future<bool> signOut() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.signOut();
      _user = null;

      developer.log('Logout successful');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Logout error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign Out Test (for Phase 1)
  Future<void> logoutTest() async {
    await signOut();
  }

  /// Send Password Reset Email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(email);

      developer.log('Password reset email sent to: $email');
      _isLoading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Failed to send reset email';
      developer.log('Password reset error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Unexpected error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update Profile
  Future<bool> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateProfile(name: name, photoUrl: photoUrl);

      if (_user != null) {
        _user = User(
          uid: _user!.uid,
          email: _user!.email,
          name: name ?? _user!.name,
          profileImageUrl: photoUrl ?? _user!.profileImageUrl,
          createdAt: _user!.createdAt,
        );
      }

      developer.log('Profile updated successfully');
      _isLoading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Failed to update profile';
      developer.log('Update profile error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Unexpected error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}