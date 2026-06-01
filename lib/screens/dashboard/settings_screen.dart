import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Theme Settings
            _buildSectionHeader(context, 'Appearance'),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark theme'),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) {
                    themeProvider.toggleDarkMode();
                  },
                );
              },
            ),
            const Divider(),
            // Notification Settings
            _buildSectionHeader(context, 'Notifications'),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive financial alerts and reminders'),
                  value: themeProvider.notificationsEnabled,
                  onChanged: (_) {
                    themeProvider.toggleNotifications();
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Notification Types'),
              subtitle: const Text('Budget alerts, Goals reminders, etc'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _showNotificationSettings(context);
              },
            ),
            const Divider(),
            // Currency Settings
            _buildSectionHeader(context, 'Currency'),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return ListTile(
                  leading: const Icon(Icons.currency_rupee),
                  title: const Text('Currency'),
                  subtitle: Text(
                    'Current: ${themeProvider.selectedCurrency}',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    _showCurrencyPicker(context, themeProvider);
                  },
                );
              },
            ),
            const Divider(),
            // Account Settings
            _buildSectionHeader(context, 'Account'),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security'),
              subtitle: const Text('Change password, etc'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _showSecuritySettings(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              subtitle: const Text('Permanently delete your account'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
            const Divider(),
            // About
            _buildSectionHeader(context, 'About'),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version'),
              subtitle: const Text(AppConstants.appVersion),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy Policy'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms & Conditions'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.primaryColor),
              ),
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Text(
                'Notification Preferences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            CheckboxListTile(
              title: const Text('Budget Alerts'),
              subtitle: const Text('Get notified when spending exceeds limit'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Goal Reminders'),
              subtitle:
                  const Text('Remind me of my savings goals'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Monthly Summary'),
              subtitle: const Text('Monthly financial summary'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Investment Tips'),
              subtitle: const Text('Investment opportunities and tips'),
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showCurrencyPicker(BuildContext context, ThemeProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Text(
                'Select Currency',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              title: const Text('Indian Rupee (₹)'),
              onTap: () {
                provider.changeCurrency('₹');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('US Dollar (\$)'),
              onTap: () {
                provider.changeCurrency('\$');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Euro (€)'),
              onTap: () {
                provider.changeCurrency('€');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showSecuritySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Security settings coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact support to delete account'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
