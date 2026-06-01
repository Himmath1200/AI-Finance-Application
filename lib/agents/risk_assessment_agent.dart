import 'package:ai_finance_platform/models/index.dart';

/// Risk Assessment Agent - Determines investment risk level
class RiskAssessmentAgent {
  /// Determine risk level based on age and other factors
  String assessRiskLevel(int age, {bool? isConservative}) {
    if (age < 30) {
      return isConservative == true ? 'Low' : 'High';
    } else if (age < 50) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  /// Get detailed risk profile
  Map<String, dynamic> getRiskProfile(FinanceData financeData) {
    final riskLevel = assessRiskLevel(financeData.age);
    final riskScore = _calculateRiskScore(financeData);

    return {
      'riskLevel': riskLevel,
      'riskScore': riskScore,
      'description': _getRiskDescription(riskLevel),
      'investmentHorizon': _getInvestmentHorizon(financeData.age),
      'recommendedAllocation': _getAssetAllocation(riskLevel),
    };
  }

  /// Calculate risk score (0-100)
  int _calculateRiskScore(FinanceData financeData) {
    int score = 50; // Base score

    // Age factor
    if (financeData.age < 30) {
      score += 30;
    } else if (financeData.age < 50) {
      score += 15;
    }

    // Income stability factor
    if (financeData.income > 100000) {
      score += 10;
    }

    // Savings capacity factor
    if (financeData.savingsRatio > 30) {
      score += 5;
    }

    return score.clamp(0, 100);
  }

  /// Get risk level description
  String _getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return 'You can afford higher volatility. Focus on growth-oriented investments.';
      case 'Medium':
        return 'Balanced approach: mix of growth and stability. Moderate risk acceptance.';
      case 'Low':
        return 'Conservative approach: prioritize capital preservation over growth.';
      default:
        return 'Unknown risk level';
    }
  }

  /// Get investment horizon based on age
  String _getInvestmentHorizon(int age) {
    final yearsToRetirement = 65 - age;
    if (yearsToRetirement > 25) {
      return 'Long-term (25+ years)';
    } else if (yearsToRetirement > 15) {
      return 'Medium-term (15-25 years)';
    } else if (yearsToRetirement > 5) {
      return 'Short-term (5-15 years)';
    } else {
      return 'Very short-term (< 5 years)';
    }
  }

  /// Get recommended asset allocation
  Map<String, int> _getAssetAllocation(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return {
          'Stocks': 70,
          'Bonds': 20,
          'Cash': 10,
        };
      case 'Medium':
        return {
          'Stocks': 50,
          'Bonds': 35,
          'Cash': 15,
        };
      case 'Low':
        return {
          'Stocks': 30,
          'Bonds': 50,
          'Cash': 20,
        };
      default:
        return {
          'Stocks': 50,
          'Bonds': 35,
          'Cash': 15,
        };
    }
  }
}
