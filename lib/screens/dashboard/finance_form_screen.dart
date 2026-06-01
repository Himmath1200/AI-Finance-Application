import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// Finance Form Screen - For entering financial information
class FinanceFormScreen extends StatefulWidget {
  const FinanceFormScreen({Key? key}) : super(key: key);

  @override
  State<FinanceFormScreen> createState() => _FinanceFormScreenState();
}

class _FinanceFormScreenState extends State<FinanceFormScreen> {
  late TextEditingController _incomeController;
  late TextEditingController _expensesController;
  late TextEditingController _ageController;
  late TextEditingController _goalController;
  late TextEditingController _monthsController;
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
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    _ageController.dispose();
    _goalController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Information'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tell us about your finances',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This information helps us provide better recommendations',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 32),
                  // Income Field
                  CustomTextField(
                    label: 'Monthly Income (₹)',
                    hint: 'Enter your monthly income',
                    controller: _incomeController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.currency_rupee,
                    validator: (value) => Validators.validatePositiveNumber(
                      value,
                      fieldName: 'Income',
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  // Expenses Field
                  CustomTextField(
                    label: 'Monthly Expenses (₹)',
                    hint: 'Enter your monthly expenses',
                    controller: _expensesController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.shopping_cart,
                    validator: (value) => Validators.validatePositiveNumber(
                      value,
                      fieldName: 'Expenses',
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  // Age Field
                  CustomTextField(
                    label: 'Your Age',
                    hint: 'Enter your age',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.cake,
                    validator: Validators.validateAge,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  // Savings Goal
                  CustomTextField(
                    label: 'Savings Goal (₹)',
                    hint: 'Enter your savings goal',
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.track_changes,
                    validator: (value) => Validators.validatePositiveNumber(
                      value,
                      fieldName: 'Savings Goal',
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  // Months
                  CustomTextField(
                    label: 'Duration (Months)',
                    hint: 'How many months to save',
                    controller: _monthsController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.calendar_month,
                    validator: Validators.validateMonths,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  // Risk Level Dropdown
                  CustomDropdown(
                    label: 'Risk Level',
                    value: _selectedRiskLevel,
                    items: const [
                      AppConstants.riskLevelLow,
                      AppConstants.riskLevelMedium,
                      AppConstants.riskLevelHigh,
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRiskLevel = value;
                      });
                    },
                    hint: 'Select your risk preference',
                  ),
                  const SizedBox(height: 24),
                  // Info Card
                  Card(
                    elevation: 0,
                    color: Colors.blue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your information is encrypted and stored securely',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Submit Button
                  Consumer<FinanceProvider>(
                    builder: (context, financeProvider, _) {
                      return PrimaryButton(
                        label: 'Save & Continue',
                        isLoading: financeProvider.isLoading,
                        onPressed: () => _handleSaveFinanceData(
                          context,
                          financeProvider,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSaveFinanceData(
    BuildContext context,
    FinanceProvider financeProvider,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRiskLevel == null) {
      SnackbarHelper.showError(
        context,
        'Please select a risk level',
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser == null) {
      SnackbarHelper.showError(
        context,
        'User not authenticated',
      );
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
          context,
          'Financial data saved successfully!',
        );
        Navigator.pushReplacementNamed(
          context,
          AppConstants.dashboardRoute,
        );
      } else {
        SnackbarHelper.showError(
          context,
          financeProvider.errorMessage ?? 'Failed to save data',
        );
      }
    }
  }
}
