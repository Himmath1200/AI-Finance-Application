import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

class FinanceFormScreen extends StatefulWidget {
  const FinanceFormScreen({Key? key}) : super(key: key);

  @override
  State<FinanceFormScreen> createState() => _FinanceFormScreenState();
}

class _FinanceFormScreenState extends State<FinanceFormScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _incomeController;
  late TextEditingController _expensesController;
  late TextEditingController _ageController;
  late TextEditingController _goalController;
  late TextEditingController _monthsController;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  String? _selectedRiskLevel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController();
    _expensesController = TextEditingController();
    _ageController = TextEditingController();
    _goalController = TextEditingController();
    _monthsController = TextEditingController();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    _ageController.dispose();
    _goalController.dispose();
    _monthsController.dispose();
    _animController.dispose();
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
          'Financial Setup',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1E3C),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1A3A6B)),
            ),
            child: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Hero heading ───────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF0D1E3C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: const Color(0xFF1A3A6B)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 28),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Finances',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'We\'ll tailor AI recommendations just for you',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Form card ──────────────────────────────────────────
                    _buildSection(
                      title: 'Income & Expenses',
                      icon: Icons.currency_rupee_rounded,
                      children: [
                        CustomTextField(
                          label: 'Monthly Income (₹)',
                          hint: 'e.g. 50000',
                          controller: _incomeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.currency_rupee_rounded,
                          validator: (v) => Validators.validatePositiveNumber(
                              v,
                              fieldName: 'Income'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Monthly Expenses (₹)',
                          hint: 'e.g. 25000',
                          controller: _expensesController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.shopping_cart_rounded,
                          validator: (v) => Validators.validatePositiveNumber(
                              v,
                              fieldName: 'Expenses'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSection(
                      title: 'Savings Goal',
                      icon: Icons.track_changes_rounded,
                      children: [
                        CustomTextField(
                          label: 'Target Amount (₹)',
                          hint: 'e.g. 100000',
                          controller: _goalController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.flag_rounded,
                          validator: (v) => Validators.validatePositiveNumber(
                              v,
                              fieldName: 'Savings Goal'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Duration (Months)',
                          hint: 'e.g. 12',
                          controller: _monthsController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.calendar_month_rounded,
                          validator: Validators.validateMonths,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildSection(
                      title: 'Profile & Risk',
                      icon: Icons.person_rounded,
                      children: [
                        CustomTextField(
                          label: 'Your Age',
                          hint: 'e.g. 28',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.cake_rounded,
                          validator: Validators.validateAge,
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          label: 'Risk Level',
                          value: _selectedRiskLevel,
                          items: const [
                            AppConstants.riskLevelLow,
                            AppConstants.riskLevelMedium,
                            AppConstants.riskLevelHigh,
                          ],
                          onChanged: (v) =>
                              setState(() => _selectedRiskLevel = v),
                          hint: 'Select your risk preference',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Security notice ────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1E36),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFF2979FF).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_rounded,
                              color: Color(0xFF2979FF), size: 22),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Your data is encrypted and stored securely',
                              style: TextStyle(
                                color: Color(0xFF8BA3C9),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Submit ─────────────────────────────────────────────
                    Consumer<FinanceProvider>(
                      builder: (context, financeProvider, _) {
                        return PrimaryButton(
                          label: 'Save & Continue',
                          icon: Icons.arrow_forward_rounded,
                          isLoading: financeProvider.isLoading,
                          onPressed: () =>
                              _handleSave(context, financeProvider),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF091428),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A3A6B)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2979FF).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2979FF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(icon, color: const Color(0xFF2979FF), size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  void _handleSave(
      BuildContext context, FinanceProvider financeProvider) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRiskLevel == null) {
      SnackbarHelper.showError(context, 'Please select a risk level');
      return;
    }
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser == null) {
      SnackbarHelper.showError(context, 'User not authenticated');
      return;
    }
    final success = await financeProvider.saveFinanceData(
      uid: authProvider.currentUser!.uid,
      income: double.parse(_incomeController.text),
      expenses: double.parse(_expensesController.text),
      age: int.parse(_ageController.text),
      goalAmount: double.parse(_goalController.text),
      months: int.parse(_monthsController.text),
      riskLevel: _selectedRiskLevel!,
    );
    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(
            context, 'Financial data saved successfully!');
        Navigator.pushReplacementNamed(context, AppConstants.dashboardRoute);
      } else {
        SnackbarHelper.showError(
            context, financeProvider.errorMessage ?? 'Failed to save data');
      }
    }
  }
}
