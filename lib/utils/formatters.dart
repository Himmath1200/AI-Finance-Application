import 'package:intl/intl.dart';

/// Formatters for displaying data
class Formatters {
  /// Format currency
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    return '$symbol${formatter.format(amount)}';
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format date
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date with time
  static String formatDatetime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  /// Format time
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format number with thousands separator
  static String formatNumber(double number, {int decimals = 0}) {
    final formatter = NumberFormat('#,##,##0', 'en_IN');
    if (decimals > 0) {
      return number.toStringAsFixed(decimals);
    }
    return formatter.format(number);
  }

  /// Format large numbers with K, M, B suffix
  static String formatCompactNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  /// Format risk level with emoji
  static String formatRiskLevel(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return '🟢 Low Risk';
      case 'medium':
        return '🟡 Medium Risk';
      case 'high':
        return '🔴 High Risk';
      default:
        return riskLevel;
    }
  }

  /// Format investment type
  static String formatInvestmentType(String type) {
    return type
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Get duration text
  static String getDurationText(int months) {
    if (months < 12) {
      return '$months months';
    }
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) {
      return '$years year${years > 1 ? 's' : ''}';
    }
    return '$years year${years > 1 ? 's' : ''} $remainingMonths month${remainingMonths > 1 ? 's' : ''}';
  }

  /// Format financial ratio
  static String formatRatio(double ratio, {String suffix = '%'}) {
    return '${ratio.toStringAsFixed(1)}$suffix';
  }
}
