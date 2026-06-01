import 'package:flutter/material.dart';
import 'package:ai_finance_platform/utils/constants.dart';

/// App extensions
extension ColorExtension on BuildContext {
  /// Get primary color
  Color get primaryColor => const Color(AppConstants.primaryColor);

  /// Get secondary color
  Color get secondaryColor => const Color(AppConstants.secondaryColor);

  /// Get success color
  Color get successColor => const Color(AppConstants.successColor);

  /// Get error color
  Color get errorColor => const Color(AppConstants.errorColor);

  /// Get warning color
  Color get warningColor => const Color(AppConstants.warningColor);
}

extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if string is a valid email
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Check if string contains only numbers
  bool isNumeric() {
    return RegExp(r'^-?\d+(\.\d+)?$').hasMatch(this);
  }
}

extension DateTimeExtension on DateTime {
  /// Check if date is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Get days ago
  int getDaysAgo() {
    final now = DateTime.now();
    final difference = now.difference(this).inDays;
    return difference;
  }
}

extension NumberExtension on num {
  /// Check if number is between range
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Clamp number between range
  num clampBetween(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}
