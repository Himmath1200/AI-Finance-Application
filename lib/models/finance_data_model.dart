/// Finance data model for storing user's financial information
class FinanceData {
  final String id;
  final String uid;
  final double income;
  final double expenses;
  final int age;
  final double goalAmount;
  final int months;
  final String riskLevel; // Low, Medium, High
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinanceData({
    required this.id,
    required this.uid,
    required this.income,
    required this.expenses,
    required this.age,
    required this.goalAmount,
    required this.months,
    required this.riskLevel,
    required this.createdAt,
    this.updatedAt,
  });

  /// Calculate monthly savings
  double get monthlySavings {
    return goalAmount / months;
  }

  /// Calculate savings ratio
  double get savingsRatio {
    final remaining = income - expenses;
    return income > 0 ? (remaining / income) * 100 : 0;
  }

  /// Calculate expense ratio
  double get expenseRatio {
    return income > 0 ? (expenses / income) * 100 : 0;
  }

  /// Check if spending is high
  bool get isHighSpending => expenseRatio > 80;

  /// Check if spending is moderate
  bool get isModerateSpending => expenseRatio > 50 && expenseRatio <= 80;

  /// Convert FinanceData to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'income': income,
      'expenses': expenses,
      'age': age,
      'goalAmount': goalAmount,
      'months': months,
      'riskLevel': riskLevel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create FinanceData from Firestore document
  factory FinanceData.fromMap(Map<String, dynamic> map) {
    return FinanceData(
      id: map['id'] as String,
      uid: map['uid'] as String,
      income: (map['income'] as num).toDouble(),
      expenses: (map['expenses'] as num).toDouble(),
      age: map['age'] as int,
      goalAmount: (map['goalAmount'] as num).toDouble(),
      months: map['months'] as int,
      riskLevel: map['riskLevel'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  /// Create a copy with modifications
  FinanceData copyWith({
    String? id,
    String? uid,
    double? income,
    double? expenses,
    int? age,
    double? goalAmount,
    int? months,
    String? riskLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinanceData(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      age: age ?? this.age,
      goalAmount: goalAmount ?? this.goalAmount,
      months: months ?? this.months,
      riskLevel: riskLevel ?? this.riskLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
