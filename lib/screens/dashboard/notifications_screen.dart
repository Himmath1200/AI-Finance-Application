import 'package:flutter/material.dart';
import 'package:ai_finance_platform/utils/index.dart';

const _bg = Color(0xFF050D1F);
const _surface = Color(0xFF091428);
const _card = Color(0xFF0D1E3C);
const _border = Color(0xFF1A3A6B);
const _textMuted = Color(0xFF8BA3C9);
const _blue = Color(0xFF2979FF);
const _cyan = Color(0xFF00E5FF);
const _gold = Color(0xFFFFB300);
const _green = Color(0xFF00C853);
const _red = Color(0xFFCF6679);

enum _NType { alert, tip, reminder, achievement }

class _Notif {
  final String title;
  final String body;
  final _NType type;
  final String time;
  bool isRead;

  _Notif({
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_Notif> _notifications = [
    _Notif(
      title: 'Budget Alert',
      body:
          'Your monthly expenses have reached 78% of your income. Consider reducing non-essential spending.',
      type: _NType.alert,
      time: '2 min ago',
    ),
    _Notif(
      title: 'Goal Milestone Reached!',
      body:
          'Congratulations! You have reached 25% of your savings goal. Keep up the momentum!',
      type: _NType.achievement,
      time: '1 hour ago',
      isRead: true,
    ),
    _Notif(
      title: 'Investment Tip',
      body:
          'Markets are up 2.1% today. Based on your Medium risk profile, this could be a good time to review your SIP investments.',
      type: _NType.tip,
      time: '3 hours ago',
    ),
    _Notif(
      title: 'Monthly Reminder',
      body:
          'Have you updated your financial data for this month? Keeping your info current helps AI generate better recommendations.',
      type: _NType.reminder,
      time: 'Yesterday',
    ),
    _Notif(
      title: 'Savings Health Alert',
      body:
          'Your savings rate dropped below 10% this month. Try the budget tips in the AI Insights section.',
      type: _NType.alert,
      time: 'Yesterday',
    ),
    _Notif(
      title: 'Smart Tip: Emergency Fund',
      body:
          'You currently do not have an emergency fund allocation. Financial experts recommend 3–6 months of expenses saved.',
      type: _NType.tip,
      time: '2 days ago',
      isRead: true,
    ),
    _Notif(
      title: 'Weekly Review Reminder',
      body:
          'Take 5 minutes this weekend to review your spending and make sure you\'re on track with your savings goal.',
      type: _NType.reminder,
      time: '3 days ago',
      isRead: true,
    ),
    _Notif(
      title: 'New AI Feature',
      body:
          'Check out the new Savings Plan tab in AI Insights — it now shows milestone tracking and monthly allocation breakdown.',
      type: _NType.tip,
      time: '5 days ago',
      isRead: true,
    ),
    _Notif(
      title: 'Goal On Track',
      body:
          'Based on your current savings rate, you are projected to reach your savings goal within the set timeframe. Great work!',
      type: _NType.achievement,
      time: '1 week ago',
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_Notif> _filtered(_NType? type) {
    if (type == null) return _notifications;
    return _notifications.where((n) => n.type == type).toList();
  }

  int get _unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  void _markAllRead() =>
      setState(() => _notifications.forEach((n) => n.isRead = true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text(
            'Notifications',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          if (_unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_unreadCount',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ]),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                    color: _blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _blue,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: _textMuted,
          labelStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          tabs: [
            _tabLabel('All', _notifications.length),
            _tabLabel(
                'Alerts',
                _notifications
                    .where((n) => n.type == _NType.alert)
                    .length),
            _tabLabel(
                'Tips',
                _notifications
                    .where((n) => n.type == _NType.tip)
                    .length),
            _tabLabel(
                'Reminders',
                _notifications
                    .where((n) => n.type == _NType.reminder ||
                        n.type == _NType.achievement)
                    .length),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotifList(
            items: _filtered(null),
            onTap: (n) =>
                setState(() => n.isRead = true),
          ),
          _NotifList(
            items: _filtered(_NType.alert),
            onTap: (n) => setState(() => n.isRead = true),
          ),
          _NotifList(
            items: _filtered(_NType.tip),
            onTap: (n) => setState(() => n.isRead = true),
          ),
          _NotifList(
            items: _notifications
                .where((n) =>
                    n.type == _NType.reminder ||
                    n.type == _NType.achievement)
                .toList(),
            onTap: (n) => setState(() => n.isRead = true),
          ),
        ],
      ),
    );
  }

  Tab _tabLabel(String label, int count) {
    return Tab(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label),
        if (count > 0) ...[
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                  color: _textMuted, fontSize: 10),
            ),
          ),
        ],
      ]),
    );
  }
}

// ── Notification list ─────────────────────────────────────────────────────────
class _NotifList extends StatelessWidget {
  final List<_Notif> items;
  final void Function(_Notif) onTap;
  const _NotifList({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _surface,
              shape: BoxShape.circle,
              border: Border.all(color: _border),
            ),
            child: const Icon(
                Icons.notifications_off_outlined,
                color: _textMuted,
                size: 36),
          ),
          const SizedBox(height: 16),
          const Text('No notifications',
              style:
                  TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 6),
          const Text('You\'re all caught up!',
              style:
                  TextStyle(color: _textMuted, fontSize: 13)),
        ]),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      itemBuilder: (_, i) => _NotifCard(
        notif: items[i],
        onTap: () => onTap(items[i]),
      ),
    );
  }
}

// ── Notification card ─────────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onTap;
  const _NotifCard({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _typeStyle(notif.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? _surface : _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                notif.isRead ? _border : color.withOpacity(0.4),
          ),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                Flexible(
                  child: Text(
                    notif.title,
                    style: TextStyle(
                      color: notif.isRead
                          ? _textMuted
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(notif.time,
                    style: const TextStyle(
                        color: _textMuted,
                        fontSize: 10)),
              ]),
              const SizedBox(height: 5),
              Text(
                notif.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: _textMuted,
                    fontSize: 12,
                    height: 1.45),
              ),
              const SizedBox(height: 6),
              _TypeChip(type: notif.type, color: color),
            ]),
          ),

          // Unread dot
          if (!notif.isRead)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 2),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
        ]),
      ),
    );
  }

  static (IconData, Color) _typeStyle(_NType type) {
    return switch (type) {
      _NType.alert => (Icons.warning_amber_rounded, _red),
      _NType.tip => (Icons.lightbulb_outline_rounded, _gold),
      _NType.reminder => (Icons.alarm_rounded, _cyan),
      _NType.achievement =>
        (Icons.emoji_events_rounded, _green),
    };
  }
}

class _TypeChip extends StatelessWidget {
  final _NType type;
  final Color color;
  const _TypeChip({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      _NType.alert => 'Alert',
      _NType.tip => 'Tip',
      _NType.reminder => 'Reminder',
      _NType.achievement => 'Achievement',
    };

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600)),
    );
  }
}
