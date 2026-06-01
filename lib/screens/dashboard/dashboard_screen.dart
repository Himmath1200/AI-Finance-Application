import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

/// Dashboard Screen - Main dashboard showing financial overview
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  void _loadFinanceData() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      context
          .read<FinanceProvider>()
          .loadFinanceData(authProvider.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFinanceData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, financeProvider, _) {
          if (financeProvider.isLoading) {
            return const Center(
              child: LoadingIndicator(message: 'Loading your data...'),
            );
          }

          if (financeProvider.currentFinanceData == null) {
            return Center(
              child: EmptyState(
                icon: Icons.account_balance_wallet,
                title: 'No Financial Data',
                message:
                    'Please add your financial information to get started',
                onRetry: () {
                  Navigator.pushNamed(
                    context,
                    AppConstants.financeFormRoute,
                  );
                },
              ),
            );
          }

          final financeData = financeProvider.currentFinanceData!;

          return RefreshIndicator(
            onRefresh: () async {
              _loadFinanceData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppConstants.paddingMedium,
                      crossAxisSpacing: AppConstants.paddingMedium,
                      children: [
                        GradientCard(
                          title: 'Monthly Income',
                          value: Formatters.formatCurrency(financeData.income),
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                          icon: Icons.trending_up,
                        ),
                        GradientCard(
                          title: 'Monthly Expenses',
                          value:
                              Formatters.formatCurrency(financeData.expenses),
                          colors: [
                            Colors.orange.shade400,
                            Colors.orange.shade600,
                          ],
                          icon: Icons.trending_down,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // More Info Cards
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppConstants.paddingMedium,
                      crossAxisSpacing: AppConstants.paddingMedium,
                      children: [
                        FinanceCard(
                          title: 'Savings Goal',
                          value: Formatters.formatCurrency(financeData.goalAmount),
                          subtitle: financeData.months.toString() + ' months',
                          icon: Icons.track_changes,
                        ),
                        FinanceCard(
                          title: 'Risk Level',
                          value: financeData.riskLevel,
                          subtitle:
                              'Age: ${financeData.age} years',
                          icon: Icons.assessment,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // Monthly Savings Recommendation
                    FinanceCard(
                      title: 'Monthly Savings Target',
                      value: Formatters.formatCurrency(
                        financeData.monthlySavings,
                      ),
                      subtitle:
                          'To reach your goal on time',
                      backgroundColor:
                          Color(AppConstants.successColor).withOpacity(0.1),
                      titleColor: const Color(AppConstants.successColor),
                      valueColor: const Color(AppConstants.successColor),
                      icon: Icons.savings,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // Expense Ratio Chart
                    _buildExpenseChart(financeData),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // AI Recommendations Button
                    PrimaryButton(
                      label: 'Get AI Recommendations',
                      onPressed: () => _showAIRecommendations(
                        context,
                        financeProvider,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Update Finance',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppConstants.financeFormRoute,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: SecondaryButton(
                            label: 'View Analysis',
                            onPressed: () {
                              _showFinanceAnalysis(
                                context,
                                financeProvider,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _navigateBottomBar(context, index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseChart(
    dynamic financeData,
  ) {
    final expenseRatio = financeData.expenseRatio;
    final savingsRatio = (100 - expenseRatio).toDouble();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense vs Savings',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.orange.shade400,
                      value: expenseRatio,
                      title: '${expenseRatio.toStringAsFixed(1)}%',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      color: Colors.green.shade400,
                      value: savingsRatio,
                      title: '${savingsRatio.toStringAsFixed(1)}%',
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend(
                  'Expenses',
                  '${expenseRatio.toStringAsFixed(1)}%',
                  Colors.orange.shade400,
                ),
                _buildLegend(
                  'Savings',
                  '${savingsRatio.toStringAsFixed(1)}%',
                  Colors.green.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  void _navigateBottomBar(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Dashboard
        break;
      case 1:
        Navigator.pushNamed(context, AppConstants.profileRoute);
        break;
      case 2:
        Navigator.pushNamed(context, AppConstants.settingsRoute);
        break;
    }
  }

  void _showAIRecommendations(
    BuildContext context,
    FinanceProvider financeProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI Financial Recommendations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<FinanceProvider>(
                      builder: (context, provider, _) {
                        if (provider.aiRecommendation == null) {
                          return Column(
                            children: [
                              const LoadingIndicator(
                                message: 'Generating recommendations...',
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                label: 'Generate Now',
                                onPressed: () {
                                  provider.generateAIRecommendation();
                                },
                              ),
                            ],
                          );
                        }

                        return Card(
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
                            child: Text(
                              provider.aiRecommendation!,
                              style:
                                  Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFinanceAnalysis(
    BuildContext context,
    FinanceProvider financeProvider,
  ) {
    final analysis = financeProvider.getExpenseAnalysis();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Financial Analysis',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (analysis.isNotEmpty) ...[
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge,
                          ),
                        ),
                        color:
                            Colors.blue.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                          child: Text(
                            analysis['analysis'] ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
