import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

/// OpenAI API Service for generating financial recommendations
class AIService {
  String? get _apiKey {
    try {
      return dotenv.env['OPENAI_API_KEY'];
    } catch (e) {
      developer.log('OpenAI API key not available: $e');
      return null;
    }
  }

  /// Generate financial recommendation using OpenAI API
  Future<String> generateFinancialRecommendation({
    required double income,
    required double expenses,
    required int age,
    required String riskLevel,
    required double savingsGoal,
  }) async {
    try {
      if (_apiKey == null || _apiKey!.isEmpty) {
        developer.log('OpenAI API key not found in environment variables');
        return _getDefaultRecommendation(
          income,
          expenses,
          age,
          riskLevel,
          savingsGoal,
        );
      }

      final prompt = '''
You are a professional financial advisor AI. Based on the following financial profile, provide a comprehensive and personalized financial recommendation:

Financial Profile:
- Monthly Income: ₹${income.toStringAsFixed(2)}
- Monthly Expenses: ₹${expenses.toStringAsFixed(2)}
- Age: $age years
- Risk Level: $riskLevel
- Savings Goal: ₹${savingsGoal.toStringAsFixed(2)}

Please provide:
1. A brief assessment of the current financial situation
2. Specific actionable recommendations for expense management
3. Investment strategy recommendations
4. Steps to achieve the savings goal
5. Risk considerations based on age and profile

Keep the response concise and professional, formatted for easy reading.
      ''';

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final recommendation =
            data['choices'][0]['message']['content'] as String;
        return recommendation;
      } else {
        developer.log(
          'OpenAI API error: ${response.statusCode} - ${response.body}',
        );
        return _getDefaultRecommendation(
          income,
          expenses,
          age,
          riskLevel,
          savingsGoal,
        );
      }
    } catch (e) {
      developer.log('Error generating recommendation: $e', error: e);
      return _getDefaultRecommendation(
        income,
        expenses,
        age,
        riskLevel,
        savingsGoal,
      );
    }
  }

  /// Get default recommendation when API is unavailable
  String _getDefaultRecommendation(
    double income,
    double expenses,
    int age,
    String riskLevel,
    double savingsGoal,
  ) {
    final remainingAmount = income - expenses;
    final savingsRatio = (remainingAmount / income * 100).toStringAsFixed(1);

    return '''
📊 Financial Analysis Report

Current Situation:
• Monthly Income: ₹${income.toStringAsFixed(2)}
• Monthly Expenses: ₹${expenses.toStringAsFixed(2)}
• Available for Savings: ₹${remainingAmount.toStringAsFixed(2)} (${savingsRatio}%)
• Age: $age years

Risk Assessment:
• Risk Level: $riskLevel
• Profile: You have been assessed as a $riskLevel risk investor

Recommendations:

1. Budget Management:
   - Track your spending regularly
   - Allocate 50% to needs, 30% to wants, 20% to savings
   - Review expenses monthly

2. Savings Strategy:
   - Target savings goal: ₹${savingsGoal.toStringAsFixed(2)}
   - Monthly savings needed: ₹${(savingsGoal / 12).toStringAsFixed(2)}
   - Create automatic transfers to savings account

3. Investment Strategy (for $riskLevel risk):
${_getInvestmentAdvice(riskLevel)}

4. Emergency Fund:
   - Build 3-6 months of expenses as emergency fund
   - Current target: ₹${(expenses * 3).toStringAsFixed(2)} to ₹${(expenses * 6).toStringAsFixed(2)}

5. Action Items:
   - Start emergency fund immediately
   - Begin regular investments next month
   - Review and adjust budget quarterly
   - Increase income or reduce expenses by 10% to accelerate goals

Remember: Consistent small steps lead to significant financial success!
    ''';
  }

  /// Get investment advice based on risk level
  String _getInvestmentAdvice(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return '''   - Allocate 70% to growth stocks/equity funds
   - 20% to balanced mutual funds
   - 10% to bonds/stable investments
   - Expected returns: 10-12% annually''';
      case 'Medium':
        return '''   - Allocate 50% to mixed equity funds
   - 35% to debt funds/bonds
   - 15% to stable instruments
   - Expected returns: 8-10% annually''';
      case 'Low':
        return '''   - Allocate 30% to equity/balanced funds
   - 50% to bonds/debt funds
   - 20% to fixed deposits/safe instruments
   - Expected returns: 6-8% annually''';
      default:
        return '   - Consult with a financial advisor for personalized guidance';
    }
  }
}
