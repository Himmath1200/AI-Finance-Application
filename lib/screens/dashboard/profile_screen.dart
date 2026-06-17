import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

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
      backgroundColor: const Color(0xFF050D1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050D1F),
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _showEditDialog(context),
              icon: const Icon(Icons.edit_rounded,
                  color: Color(0xFF2979FF), size: 16),
              label: const Text('Edit',
                  style: TextStyle(color: Color(0xFF2979FF), fontSize: 13)),
            ),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.currentUser;
          if (user == null) {
            return const Center(
              child: Text('User not found',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final initial = user.name.isNotEmpty
              ? user.name.substring(0, 1).toUpperCase()
              : '?';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ── Avatar hero ──────────────────────────────────────────
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1565C0), Color(0xFF2979FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2979FF).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 44,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF050D1F), width: 2),
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: Color(0xFF8BA3C9),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                // ── Verified badge ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF002B14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            const Color(0xFF00C853).withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.verified_rounded,
                          color: Color(0xFF00C853), size: 13),
                      SizedBox(width: 5),
                      Text('Verified Account',
                          style: TextStyle(
                              color: Color(0xFF00C853),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Info cards ───────────────────────────────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ACCOUNT DETAILS',
                    style: TextStyle(
                      color: Color(0xFF2979FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  icon: Icons.email_rounded,
                  title: 'Email Address',
                  value: user.email,
                  iconColor: const Color(0xFF2979FF),
                ),
                const SizedBox(height: 10),
                InfoCard(
                  icon: Icons.person_rounded,
                  title: 'Full Name',
                  value: user.name,
                  iconColor: const Color(0xFF00E5FF),
                ),
                const SizedBox(height: 10),
                InfoCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'Member Since',
                  value: Formatters.formatDate(user.createdAt),
                  iconColor: const Color(0xFFFFB300),
                ),

                const SizedBox(height: 28),

                // ── Actions ───────────────────────────────────────────────
                PrimaryButton(
                  label: 'Edit Profile',
                  icon: Icons.edit_rounded,
                  onPressed: () => _showEditDialog(context),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Update Financial Data',
                  icon: Icons.account_balance_wallet_rounded,
                  onPressed: () => Navigator.pushNamed(
                      context, AppConstants.financeFormRoute),
                ),
                const SizedBox(height: 12),

                // Logout — red tint outlined button
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusLarge),
                    border: Border.all(
                        color: const Color(0xFFCF6679).withOpacity(0.5)),
                    color: const Color(0xFF2A0D0D).withOpacity(0.4),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusLarge),
                    child: InkWell(
                      onTap: () => _handleLogout(context),
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.logout_rounded,
                              color: Color(0xFFCF6679), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Color(0xFFCF6679),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF091428),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1A3A6B)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                prefixIcon: Icons.person_rounded,
                validator: Validators.validateName,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel',
                          style: TextStyle(color: Color(0xFF8BA3C9))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) => PrimaryButton(
                        label: 'Save',
                        isLoading: auth.isLoading,
                        onPressed: () async {
                          final success = await auth.updateProfile(
                              name: _nameController.text.trim());
                          if (mounted) {
                            Navigator.pop(ctx);
                            if (success) {
                              SnackbarHelper.showSuccess(
                                  context, 'Profile updated!');
                            } else {
                              SnackbarHelper.showError(
                                  context, 'Failed to update profile');
                            }
                          }
                        },
                      ),
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

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
                child: const Icon(Icons.logout_rounded,
                    color: Color(0xFFCF6679), size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Sign Out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Are you sure you want to sign out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF8BA3C9), fontSize: 13)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) => Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B1A1A),
                              Color(0xFFCF6679),
                            ],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusLarge),
                            onTap: () async {
                              await auth.signOut();
                              if (mounted) {
                                Navigator.pushReplacementNamed(context,
                                    AppConstants.loginRoute);
                              }
                            },
                            child: const Center(
                              child: Text('Sign Out',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
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
