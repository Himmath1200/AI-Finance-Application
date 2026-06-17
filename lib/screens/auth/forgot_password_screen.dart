import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _emailController;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1E3C),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1A3A6B)),
            ),
            child: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ── Icon + heading ────────────────────────────────────────
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2552),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1A3A6B)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2979FF).withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Icon(
                      _emailSent
                          ? Icons.mark_email_read_rounded
                          : Icons.lock_reset_rounded,
                      size: 40,
                      color: const Color(0xFF2979FF),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _emailSent ? 'Check Your Inbox' : 'Reset Password',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _emailSent
                          ? 'We\'ve sent a password reset link to your email. Please check your inbox.'
                          : 'Enter your email address and we\'ll send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF8BA3C9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  if (!_emailSent) ...[
                    // ── Form card ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF091428),
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: const Color(0xFF1A3A6B)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2979FF).withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Email Address',
                              hint: 'you@example.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 24),
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return PrimaryButton(
                                  label: 'Send Reset Link',
                                  icon: Icons.send_rounded,
                                  isLoading: auth.isLoading,
                                  onPressed: () =>
                                      _handleReset(context),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // ── Success state ─────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A2B1A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF00C853).withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF00C853), size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Reset link sent to ${_emailController.text}',
                              style: const TextStyle(
                                color: Color(0xFF00C853),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Back to Login',
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppConstants.loginRoute),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleReset(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth
        .sendPasswordResetEmail(_emailController.text.trim());
    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(
            context, 'Password reset link sent!');
        setState(() => _emailSent = true);
      } else {
        SnackbarHelper.showError(
            context, auth.errorMessage ?? 'Failed to send reset link');
      }
    }
  }
}
