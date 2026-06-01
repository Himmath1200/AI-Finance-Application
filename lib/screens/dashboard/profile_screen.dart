import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _nameController = TextEditingController(
      text: authProvider.currentUser?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text('User not found'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Profile Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(AppConstants.primaryColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // User Info
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 32),
                  // Profile Details Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusLarge,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      child: Column(
                        children: [
                          InfoCard(
                            icon: Icons.email,
                            title: 'Email',
                            value: user.email,
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          InfoCard(
                            icon: Icons.calendar_today,
                            title: 'Member Since',
                            value: Formatters.formatDate(user.createdAt),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action Buttons
                  PrimaryButton(
                    label: 'Edit Profile',
                    onPressed: () => _showEditProfileDialog(context),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Change Password',
                    onPressed: () {
                      SnackbarHelper.showInfo(
                        context,
                        'Password change is available in Settings',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Logout',
                    onPressed: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: CustomTextField(
            label: 'Name',
            controller: _nameController,
            prefixIcon: Icons.person,
            validator: Validators.validateName,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return TextButton(
                  onPressed: () async {
                    final success = await authProvider.updateProfile(
                      name: _nameController.text,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      if (success) {
                        SnackbarHelper.showSuccess(
                          context,
                          'Profile updated successfully',
                        );
                      } else {
                        SnackbarHelper.showError(
                          context,
                          'Failed to update profile',
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return TextButton(
                  onPressed: () async {
                    await authProvider.signOut();
                    if (mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppConstants.loginRoute,
                      );
                    }
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
