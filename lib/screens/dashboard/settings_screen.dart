import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/utils/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050D1F),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Appearance ─────────────────────────────────────────────
            const SectionHeader(title: 'Appearance'),
            _buildCard(children: [
              Consumer<ThemeProvider>(
                builder: (_, themeProvider, __) => _buildToggleTile(
                  icon: Icons.dark_mode_rounded,
                  iconColor: const Color(0xFF82B1FF),
                  title: 'Dark Mode',
                  subtitle: 'Premium dark interface',
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleDarkMode(),
                ),
              ),
            ]),

            const SectionHeader(title: 'Notifications'),
            _buildCard(children: [
              Consumer<ThemeProvider>(
                builder: (_, themeProvider, __) => _buildToggleTile(
                  icon: Icons.notifications_rounded,
                  iconColor: const Color(0xFF00E5FF),
                  title: 'Push Notifications',
                  subtitle: 'Financial alerts & reminders',
                  value: themeProvider.notificationsEnabled,
                  onChanged: (_) => themeProvider.toggleNotifications(),
                ),
              ),
              _buildDivider(),
              _buildArrowTile(
                context: context,
                icon: Icons.tune_rounded,
                iconColor: const Color(0xFF00E5FF),
                title: 'Notification Types',
                subtitle: 'Budget alerts, goal reminders',
                onTap: () => _showNotificationSheet(context),
              ),
            ]),

            const SectionHeader(title: 'Currency'),
            Consumer<ThemeProvider>(
              builder: (_, themeProvider, __) => _buildCard(children: [
                _buildArrowTile(
                  context: context,
                  icon: Icons.currency_rupee_rounded,
                  iconColor: const Color(0xFFFFB300),
                  title: 'Currency',
                  subtitle: 'Current: ${themeProvider.selectedCurrency}',
                  onTap: () => _showCurrencySheet(context, themeProvider),
                ),
              ]),
            ),

            const SectionHeader(title: 'Account'),
            _buildCard(children: [
              _buildArrowTile(
                context: context,
                icon: Icons.security_rounded,
                iconColor: const Color(0xFF00C853),
                title: 'Security',
                subtitle: 'Password & authentication',
                onTap: () => SnackbarHelper.showInfo(
                    context, 'Security settings coming soon'),
              ),
              _buildDivider(),
              _buildArrowTile(
                context: context,
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF2979FF),
                title: 'Edit Profile',
                subtitle: 'Update your name & details',
                onTap: () =>
                    Navigator.pushNamed(context, AppConstants.profileRoute),
              ),
              _buildDivider(),
              _buildArrowTile(
                context: context,
                icon: Icons.delete_outline_rounded,
                iconColor: const Color(0xFFCF6679),
                title: 'Delete Account',
                subtitle: 'Permanently remove your account',
                onTap: () => _showDeleteDialog(context),
                isDestructive: true,
              ),
            ]),

            const SectionHeader(title: 'About'),
            _buildCard(children: [
              _buildInfoTile(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF8BA3C9),
                title: 'App Version',
                subtitle: AppConstants.appVersion,
              ),
              _buildDivider(),
              _buildArrowTile(
                context: context,
                icon: Icons.privacy_tip_outlined,
                iconColor: const Color(0xFF8BA3C9),
                title: 'Privacy Policy',
                onTap: () =>
                    SnackbarHelper.showInfo(context, 'Privacy Policy'),
              ),
              _buildDivider(),
              _buildArrowTile(
                context: context,
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF8BA3C9),
                title: 'Terms & Conditions',
                onTap: () =>
                    SnackbarHelper.showInfo(context, 'Terms & Conditions'),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF091428),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A3A6B)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(
        height: 1, color: Color(0xFF1A3A6B), indent: 56, endIndent: 16);
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF8BA3C9), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2979FF),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? const Color(0xFFCF6679)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle,
                        style: const TextStyle(
                            color: Color(0xFF8BA3C9), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: isDestructive
                    ? const Color(0xFFCF6679).withOpacity(0.5)
                    : const Color(0xFF4A6080),
                size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
          Text(subtitle,
              style: const TextStyle(
                  color: Color(0xFF8BA3C9), fontSize: 13)),
        ],
      ),
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF091428),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Color(0xFF1A3A6B)),
      ),
      builder: (_) {
        final items = [
          ('Budget Alerts', 'Notified when spending exceeds limit'),
          ('Goal Reminders', 'Savings goal milestone reminders'),
          ('Monthly Summary', 'End-of-month financial report'),
          ('Investment Tips', 'AI-powered investment suggestions'),
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notification Preferences',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1E3C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1A3A6B)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.$1,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              Text(item.$2,
                                  style: const TextStyle(
                                      color: Color(0xFF8BA3C9),
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                        Switch(
                            value: true,
                            onChanged: (_) {},
                            activeColor: const Color(0xFF2979FF)),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySheet(
      BuildContext context, ThemeProvider themeProvider) {
    final currencies = [
      ('Indian Rupee', '₹', Icons.currency_rupee_rounded),
      ('US Dollar', '\$', Icons.attach_money_rounded),
      ('Euro', '€', Icons.euro_rounded),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF091428),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Color(0xFF1A3A6B)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Currency',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...currencies.map((c) {
              final selected = themeProvider.selectedCurrency == c.$2;
              return InkWell(
                onTap: () {
                  themeProvider.changeCurrency(c.$2);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1565C0).withOpacity(0.2)
                        : const Color(0xFF0D1E3C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: selected
                            ? const Color(0xFF2979FF)
                            : const Color(0xFF1A3A6B)),
                  ),
                  child: Row(
                    children: [
                      Icon(c.$3,
                          color: selected
                              ? const Color(0xFF2979FF)
                              : const Color(0xFF8BA3C9),
                          size: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(c.$1,
                            style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF8BA3C9),
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal)),
                      ),
                      Text(c.$2,
                          style: TextStyle(
                              color: selected
                                  ? const Color(0xFF2979FF)
                                  : const Color(0xFF4A6080),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF2979FF), size: 18),
                      ],
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF091428),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1A3A6B)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A0D0D),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFFCF6679).withOpacity(0.4)),
                ),
                child: const Icon(Icons.delete_forever_rounded,
                    color: Color(0xFFCF6679), size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Delete Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Color(0xFF8BA3C9), fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: Color(0xFF8BA3C9))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        SnackbarHelper.showInfo(
                            context, 'Contact support to delete account');
                      },
                      child: const Text('Delete',
                          style: TextStyle(
                              color: Color(0xFFCF6679),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
