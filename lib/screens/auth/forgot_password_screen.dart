import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Header
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(AppConstants.primaryColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.mail_outline,
                    size: 50,
                    color: Color(AppConstants.primaryColor),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _emailSent ? 'Check Your Email' : 'Reset Password',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _emailSent
                      ? 'We have sent password reset link to your email'
                      : 'Enter your email address to receive a password reset link',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (!_emailSent)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email',
                          hint: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: AppConstants.paddingLarge),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return PrimaryButton(
                              label: 'Send Reset Link',
                              isLoading: authProvider.isLoading,
                              onPressed: () =>
                                  _handlePasswordReset(context),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Color(AppConstants.successColor),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Back to Login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppConstants.loginRoute,
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePasswordReset(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(
          context,
          'Password reset link sent to your email',
        );
        setState(() {
          _emailSent = true;
        });
      } else {
        SnackbarHelper.showError(
          context,
          authProvider.errorMessage ?? 'Failed to send reset link',
        );
      }
    }
  }
}
