import 'package:flutter/foundation.dart';
import 'package:ai_finance_platform/services/firebase_service.dart';
import 'package:ai_finance_platform/models/finance_data_model.dart';
import 'dart:developer' as developer;

class FinanceProvider with ChangeNotifier {
  final _dbService = RealtimeDatabaseService();
  FinanceData? _currentFinanceData;
  String? _aiRecommendation;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  FinanceData? get currentFinanceData => _currentFinanceData;
  String? get aiRecommendation => _aiRecommendation;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<FinanceData> get transactions => _currentFinanceData != null ? [_currentFinanceData!] : [];

  /// Save Finance Data
  Future<bool> saveFinanceData({
    required String uid,
    required double income,
    required double expenses,
    required int age,
    required double goalAmount,
    required int months,
    required String riskLevel,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final financeData = FinanceData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uid: uid,
        income: income,
        expenses: expenses,
        age: age,
        goalAmount: goalAmount,
        months: months,
        riskLevel: riskLevel,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _dbService.saveFinanceData(financeData);
      _currentFinanceData = financeData;
      
      developer.log('Finance data saved successfully!');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Save error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load Finance Data
  Future<void> loadFinanceData(String uid) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final data = await _dbService.getLatestFinanceData(uid);
      if (data != null) {
        _currentFinanceData = data;
        developer.log('Finance data loaded successfully!');
      } else {
        _errorMessage = 'No financial data found';
        developer.log('No financial data found');
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('Load error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate AI Recommendation based on financial data
  Future<void> generateAIRecommendation() async {
    try {
      if (_currentFinanceData == null) {
        _errorMessage = 'No financial data to analyze';
        notifyListeners();
        return;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final data = _currentFinanceData!;
      
      // Generate recommendation based on financial metrics
      String recommendation = 'Recommendations:\n\n';
      
      if (data.expenseRatio > 80) {
        recommendation += '⚠️ High Spending Alert: Your expenses are ${data.expenseRatio.toStringAsFixed(1)}% of income\n';
      } else if (data.expenseRatio > 50) {
        recommendation += '⚡ Moderate Spending: Consider optimizing your expenses\n';
      } else {
        recommendation += '✅ Healthy spending ratio: ${data.expenseRatio.toStringAsFixed(1)}%\n';
      }

      recommendation += '\n💰 Monthly Savings Target: ₹${data.monthlySavings.toStringAsFixed(2)}\n';
      recommendation += '\n📊 Savings Ratio: ${data.savingsRatio.toStringAsFixed(1)}%';

      if (data.riskLevel == 'High') {
        recommendation += '\n\n⚡ Risk Level: High - Consider diversified investments';
      } else if (data.riskLevel == 'Medium') {
        recommendation += '\n\n⚠️ Risk Level: Medium - Balanced investment approach recommended';
      } else {
        recommendation += '\n\n🛡️ Risk Level: Low - Conservative investment strategy';
      }

      _aiRecommendation = recommendation;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      developer.log('AI recommendation error: $_errorMessage');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get Expense Analysis from current finance data
  Map<String, dynamic> getExpenseAnalysis() {
    if (_currentFinanceData == null) {
      return {
        'totalExpense': 0.0,
        'expenseRatio': 0.0,
        'savingsRatio': 0.0,
        'analysis': '',
      };
    }

    final data = _currentFinanceData!;
    final remaining = data.income - data.expenses;
    String status;
    String advice;
    if (data.isHighSpending) {
      status = '⚠️ High Spending';
      advice =
          'Your expenses are ${data.expenseRatio.toStringAsFixed(1)}% of income. Consider cutting non-essential costs immediately.';
    } else if (data.isModerateSpending) {
      status = '⚡ Moderate Spending';
      advice =
          'Expenses are ${data.expenseRatio.toStringAsFixed(1)}% of income. You have room to save more — target under 50%.';
    } else {
      status = '✅ Healthy Spending';
      advice =
          'Great! Only ${data.expenseRatio.toStringAsFixed(1)}% of income goes to expenses. Keep investing the surplus.';
    }

    return {
      'totalExpense': data.expenses,
      'expenseRatio': data.expenseRatio,
      'savingsRatio': data.savingsRatio,
      'monthSavings': data.monthlySavings,
      'isHighSpending': data.isHighSpending,
      'isModerateSpending': data.isModerateSpending,
      'remaining': remaining,
      'status': status,
      'advice': advice,
      'analysis':
          '$status\n\n$advice\n\nAvailable for saving: ₹${remaining.toStringAsFixed(2)}/month',
    };
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clearFinanceData() {
    _currentFinanceData = null;
    _aiRecommendation = null;
    _errorMessage = null;
    notifyListeners();
  }
}