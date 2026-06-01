import 'package:flutter/material.dart';
import 'package:ai_finance_platform/models/index.dart';
import 'package:ai_finance_platform/services/index.dart';
import 'package:ai_finance_platform/agents/index.dart';
import 'package:uuid/uuid.dart';

/// Finance Provider for managing financial data and calculations
class FinanceProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AIService _aiService = AIService();

  FinanceData? _currentFinanceData;
  String? _aiRecommendation;
  List<InvestmentSuggestion> _investmentSuggestions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Agents
  final _expenseAnalysisAgent = ExpenseAnalysisAgent();
  final _riskAssessmentAgent = RiskAssessmentAgent();
  final _investmentSuggestionAgent = InvestmentSuggestionAgent();
  final _goalSavingsPlannerAgent = GoalSavingsPlannerAgent();

  FinanceData? get currentFinanceData => _currentFinanceData;
  String? get aiRecommendation => _aiRecommendation;
  List<InvestmentSuggestion> get investmentSuggestions => _investmentSuggestions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load finance data for user
  Future<void> loadFinanceData(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentFinanceData = await _firestoreService.getLatestFinanceData(uid);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Save new finance data
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
      notifyListeners();

      final financeData = FinanceData(
        id: const Uuid().v4(),
        uid: uid,
        income: income,
        expenses: expenses,
        age: age,
        goalAmount: goalAmount,
        months: months,
        riskLevel: riskLevel,
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveFinanceData(financeData);
      _currentFinanceData = financeData;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Generate AI recommendation
  Future<void> generateAIRecommendation() async {
    if (_currentFinanceData == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      _aiRecommendation = await _aiService.generateFinancialRecommendation(
        income: _currentFinanceData!.income,
        expenses: _currentFinanceData!.expenses,
        age: _currentFinanceData!.age,
        riskLevel: _currentFinanceData!.riskLevel,
        savingsGoal: _currentFinanceData!.goalAmount,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Get expense analysis
  Map<String, dynamic> getExpenseAnalysis() {
    if (_currentFinanceData == null) return {};
    return _expenseAnalysisAgent.analyzeExpenses(_currentFinanceData!);
  }

  /// Get risk profile
  Map<String, dynamic> getRiskProfile() {
    if (_currentFinanceData == null) return {};
    return _riskAssessmentAgent.getRiskProfile(_currentFinanceData!);
  }

  /// Get investment suggestions
  Future<void> getInvestmentSuggestions() async {
    if (_currentFinanceData == null) return;

    try {
      _investmentSuggestions = _investmentSuggestionAgent.suggestInvestments(
        _currentFinanceData!.riskLevel,
        _currentFinanceData!.income - _currentFinanceData!.expenses,
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Get savings plan
  Map<String, dynamic> getSavingsPlan() {
    if (_currentFinanceData == null) return {};
    return _goalSavingsPlannerAgent.planSavings(_currentFinanceData!);
  }

  /// Get milestones
  List<Map<String, dynamic>> getMilestones() {
    if (_currentFinanceData == null) return [];
    return _goalSavingsPlannerAgent.getMilestones(_currentFinanceData!);
  }

  /// Get savings breakdown by category
  Map<String, double> getSavingsBreakdown() {
    if (_currentFinanceData == null) return {};
    final monthlySavings = _currentFinanceData!.monthlySavings;
    return _goalSavingsPlannerAgent.getSavingsByCategory(monthlySavings);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
