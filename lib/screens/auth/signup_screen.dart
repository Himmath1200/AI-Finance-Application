import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1F),
      body: Stack(
        children: [
          // ── Decorative background circles ───────────────────────────────
          Positioned(
            top: -40,
            left: -70,
            child: _GlowCircle(
                size: 220, color: const Color(0xFF1565C0), opacity: 0.18),
          ),
          Positioned(
            top: 80,
            left: 20,
            child: _GlowCircle(
                size: 80, color: const Color(0xFF00E5FF), opacity: 0.08),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _GlowCircle(
                size: 240, color: const Color(0xFF0D47A1), opacity: 0.20),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: _GlowCircle(
                size: 90, color: const Color(0xFF2979FF), opacity: 0.10),
          ),

          // ── Main content ─────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ── Logo ────────────────────────────────────
                            const FinanceAILogo(size: 72),
                            const SizedBox(height: 16),
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [
                                  Color(0xFF82B1FF),
                                  Color(0xFFFFFFFF),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'FINANCE AI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // ── Card ─────────────────────────────────────
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.fromLTRB(28, 32, 28, 28),
                              decoration: BoxDecoration(
                                color: const Color(0xFF091428),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                    color: const Color(0xFF1A3A6B)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2979FF)
                                        .withOpacity(0.10),
                                    blurRadius: 40,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Please register to login.',
                                      style: TextStyle(
                                        color: Color(0xFF6B85A8),
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Full Name
                                    _InputField(
                                      controller: _nameController,
                                      hint: 'Username',
                                      icon: Icons.person_outline_rounded,
                                      validator: Validators.validateName,
                                    ),
                                    const SizedBox(height: 14),

                                    // Email
                                    _InputField(
                                      controller: _emailController,
                                      hint: 'Mobile Number / Email',
                                      icon: Icons.alternate_email_rounded,
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      validator: Validators.validateEmail,
                                    ),
                                    const SizedBox(height: 14),

                                    // Password
                                    _PasswordField(
                                      controller: _passwordController,
                                      hint: '••••••••••',
                                      validator:
                                          Validators.validatePassword,
                                    ),
                                    const SizedBox(height: 14),

                                    // Confirm Password
                                    _PasswordField(
                                      controller: _confirmController,
                                      hint: 'Confirm password',
                                      validator: (v) =>
                                          Validators
                                              .validateConfirmPassword(
                                                  v,
                                                  _passwordController
                                                      .text),
                                    ),

                                    const SizedBox(height: 28),

                                    // Sign Up button
                                    Consumer<AuthProvider>(
                                      builder: (context, auth, _) =>
                                          _SignUpButton(
                                        isLoading: auth.isLoading,
                                        onPressed: () =>
                                            _handleSignUp(context),
                                      ),
                                    ),

                                    const SizedBox(height: 22),

                                    // Divider
                                    Row(children: [
                                      const Expanded(
                                          child: Divider(
                                              color: Color(0xFF1A3A6B),
                                              thickness: 1)),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text('or',
                                            style: TextStyle(
                                                color: Color(0xFF3A5070),
                                                fontSize: 12)),
                                      ),
                                      const Expanded(
                                          child: Divider(
                                              color: Color(0xFF1A3A6B),
                                              thickness: 1)),
                                    ]),

                                    const SizedBox(height: 18),

                                    // Sign in link
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Already have an account? ',
                                            style: TextStyle(
                                              color: Color(0xFF6B85A8),
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator
                                                .pushReplacementNamed(
                                                    context,
                                                    AppConstants.loginRoute),
                                            child: const Text(
                                              'Sign In',
                                              style: TextStyle(
                                                color: Color(0xFF2979FF),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
    );
    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(context, 'Account created successfully!');
        Navigator.pushReplacementNamed(
            context, AppConstants.financeFormRoute);
      } else {
        SnackbarHelper.showError(
            context, auth.errorMessage ?? 'Sign up failed');
      }
    }
  }
}

// ── Decorative glow circle ────────────────────────────────────────────────────
class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle(
      {required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
        ),
      ),
    );
  }
}

// ── Generic input field ───────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: const Color(0xFF2979FF),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFF3A5070), fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Icon(icon, color: const Color(0xFF4A6080), size: 18),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 48, minHeight: 48),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF0A1628),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A5F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF2979FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFCF6679), width: 1.5),
        ),
        errorStyle:
            const TextStyle(color: Color(0xFFCF6679), fontSize: 11),
      ),
    );
  }
}

// ── Password field with toggle ────────────────────────────────────────────────
class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    this.hint = '••••••••',
    this.validator,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _InputField(
      controller: widget.controller,
      hint: widget.hint,
      icon: Icons.lock_outline_rounded,
      obscureText: _obscure,
      validator: widget.validator,
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF4A6080),
            size: 18,
          ),
        ),
      ),
    );
  }
}

// ── Sign-up button ────────────────────────────────────────────────────────────
class _SignUpButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SignUpButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(
                  colors: [Color(0xFF1A2D4A), Color(0xFF1A2D4A)])
              : const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF2979FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF2979FF).withOpacity(0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.white.withOpacity(0.08),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
