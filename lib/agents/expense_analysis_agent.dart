import 'package:ai_finance_platform/models/index.dart';

/// Expense Analysis Agent - Analyzes spending patterns and provides advice
class ExpenseAnalysisAgent {
  /// Calculate expense ratio and provide analysis
  Map<String, dynamic> analyzeExpenses(FinanceData financeData) {
    final expenseRatio = financeData.expenseRatio;
    final remaining = financeData.income - financeData.expenses;

    String analysis;
    String severity;

    if (expenseRatio > 80) {
      severity = 'High';
      analysis = 'Your spending is at ${expenseRatio.toStringAsFixed(1)}% of income. This is high and leaves very little for savings. '
          'Consider cutting non-essential expenses and creating a strict budget.';
    } else if (expenseRatio > 50) {
      severity = 'Moderate';
      analysis = 'Your spending is at ${expenseRatio.toStringAsFixed(1)}% of income. This is moderate but could be optimized. '
          'Look for opportunities to reduce unnecessary expenses.';
    } else {
      severity = 'Good';
      analysis = 'Your spending is at ${expenseRatio.toStringAsFixed(1)}% of income. Excellent financial control! '
          'You have ₹${remaining.toStringAsFixed(2)} available for savings and investments monthly.';
    }

    return {
      'severity': severity,
      'expenseRatio': expenseRatio,
      'analysis': analysis,
      'remainingAmount': remaining,
      'recommendations': _getExpenseRecommendations(expenseRatio),
    };
  }

  /// Get specific recommendations based on expense ratio
  List<String> _getExpenseRecommendations(double expenseRatio) {
    final recommendations = <String>[];

    if (expenseRatio > 80) {
      recommendations.addAll([
        'Audit all subscriptions and cancel unused ones',
        'Cook at home instead of eating out',
        'Use public transportation or carpool',
        'Shop for essentials only',
        'Negotiate bills (internet, insurance, etc.)',
      ]);
    } else if (expenseRatio > 50) {
      recommendations.addAll([
        'Track daily expenses to identify patterns',
        'Set monthly spending limits per category',
        'Look for discounts and deals',
        'Reduce entertainment spending',
        'Consider budget alternatives for services',
      ]);
    } else {
      recommendations.addAll([
        'Maintain current spending discipline',
        'Allocate extra funds to investments',
        'Build emergency fund (3-6 months expenses)',
        'Start long-term wealth creation',
      ]);
    }

    return recommendations;
  }

  /// Detect overspending in specific categories
  Map<String, double> detectOverspending(
    Map<String, double> expensesByCategory,
  ) {
    final totalExpenses =
        expensesByCategory.values.fold<double>(0, (a, b) => a + b);
    final averagePerCategory = totalExpenses / expensesByCategory.length;

    final overspent = <String, double>{};
    expensesByCategory.forEach((category, amount) {
      if (amount > averagePerCategory * 1.5) {
        overspent[category] = amount - averagePerCategory;
      }
    });

    return overspent;
  }
}
