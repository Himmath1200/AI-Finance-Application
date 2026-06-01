/// AI Recommendation model for storing AI-generated recommendations
class AIRecommendation {
  final String id;
  final String uid;
  final String recommendation;
  final String category; // savings, investment, expense, etc
  final DateTime createdAt;

  AIRecommendation({
    required this.id,
    required this.uid,
    required this.recommendation,
    required this.category,
    required this.createdAt,
  });

  /// Convert to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'recommendation': recommendation,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from Firestore document
  factory AIRecommendation.fromMap(Map<String, dynamic> map) {
    return AIRecommendation(
      id: map['id'] as String,
      uid: map['uid'] as String,
      recommendation: map['recommendation'] as String,
      category: map['category'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
