/// Investment suggestion model
class InvestmentSuggestion {
  final String id;
  final String type; // Stocks, Mutual Funds, Bonds, FD, SIP
  final String riskLevel; // Low, Medium, High
  final String description;
  final double expectedReturn; // Annual percentage
  final DateTime createdAt;

  InvestmentSuggestion({
    required this.id,
    required this.type,
    required this.riskLevel,
    required this.description,
    required this.expectedReturn,
    required this.createdAt,
  });

  /// Convert to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'riskLevel': riskLevel,
      'description': description,
      'expectedReturn': expectedReturn,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from Firestore document
  factory InvestmentSuggestion.fromMap(Map<String, dynamic> map) {
    return InvestmentSuggestion(
      id: map['id'] as String,
      type: map['type'] as String,
      riskLevel: map['riskLevel'] as String,
      description: map['description'] as String,
      expectedReturn: (map['expectedReturn'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
