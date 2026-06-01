/// Notification model for storing notification history
class NotificationModel {
  final String id;
  final String uid;
  final String title;
  final String body;
  final String type; // budget_alert, goal_reminder, monthly_reminder
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  /// Convert to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'body': body,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  /// Create from Firestore document
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      type: map['type'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isRead: map['isRead'] as bool? ?? false,
    );
  }
}
