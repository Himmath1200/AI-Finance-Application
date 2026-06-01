import 'package:ai_finance_platform/models/index.dart';

/// Goal-Based Savings Planner Agent - Plans savings to reach goals
class GoalSavingsPlannerAgent {
  /// Calculate monthly savings needed to reach goal
  Map<String, dynamic> planSavings(FinanceData financeData) {
    final monthlySavings = financeData.monthlySavings;
    final currentMonthlyAvailable = financeData.income - financeData.expenses;
    final savingsRatio = financeData.savingsRatio;

    String feasibility;
    String recommendation;

    if (currentMonthlyAvailable >= monthlySavings) {
      feasibility = 'Achievable';
      recommendation =
          'Your goal is achievable with current income-expense pattern.';
    } else if (currentMonthlyAvailable > monthlySavings * 0.5) {
      feasibility = 'Challenging';
      recommendation =
          'You need to reduce expenses or increase income to meet this goal.';
    } else {
      feasibility = 'Not Feasible';
      recommendation =
          'Current financial situation makes this goal unattainable. Consider adjusting the goal.';
    }

    return {
      'goalAmount': financeData.goalAmount,
      'timeframe': financeData.months,
      'monthlySavings': monthlySavings,
      'currentMonthlyAvailable': currentMonthlyAvailable,
      'feasibility': feasibility,
      'recommendation': recommendation,
      'savingsRatio': savingsRatio,
      'savingsPlan': _generateSavingsPlan(financeData),
    };
  }

  /// Generate detailed savings plan
  List<Map<String, dynamic>> _generateSavingsPlan(FinanceData financeData) {
    final plan = <Map<String, dynamic>>[];
    final monthlySavings = financeData.monthlySavings;

    for (int month = 1; month <= financeData.months; month++) {
      plan.add({
        'month': month,
        'targetSavings': monthlySavings * month,
        'monthlyTarget': monthlySavings,
        'remaining': financeData.goalAmount - (monthlySavings * month),
      });
    }

    return plan;
  }

  /// Get milestone-based goals
  List<Map<String, dynamic>> getMilestones(FinanceData financeData) {
    final milestones = <Map<String, dynamic>>[];
    final totalMonths = financeData.months;
    final goalAmount = financeData.goalAmount;

    // Create 4 equally-spaced milestones
    for (int i = 1; i <= 4; i++) {
      final monthAtMilestone = (totalMonths * i / 4).toInt();
      final savedAmount = financeData.monthlySavings * monthAtMilestone;

      milestones.add({
        'milestone': 'Milestone $i',
        'month': monthAtMilestone,
        'targetAmount': savedAmount,
        'progressPercentage': (savedAmount / goalAmount * 100),
      });
    }

    return milestones;
  }

  /// Calculate if extra savings can accelerate goal
  Map<String, dynamic> calculateAcceleration(
    FinanceData financeData,
    double extraMonthlySavings,
  ) {
    final totalMonthlyExtra = extraMonthlySavings;
    final reducedMonths =
        financeData.goalAmount / (financeData.monthlySavings + totalMonthlyExtra);
    final timesSaved = financeData.months - reducedMonths.toInt();

    return {
      'extraMonthlySavings': totalMonthlyExtra,
      'originalMonths': financeData.months,
      'acceleratedMonths': reducedMonths.toInt(),
      'timesSaved': timesSaved,
      'percentageFaster': (timesSaved / financeData.months * 100),
    };
  }

  /// Get category-wise savings recommendations
  Map<String, double> getSavingsByCategory(double totalMonthlySavings) {
    return {
      'Emergency Fund': totalMonthlySavings * 0.2,
      'Investments': totalMonthlySavings * 0.5,
      'Special Goals': totalMonthlySavings * 0.2,
      'Buffer': totalMonthlySavings * 0.1,
    };
  }
}
