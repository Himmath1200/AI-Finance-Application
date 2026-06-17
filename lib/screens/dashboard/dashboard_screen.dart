import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ai_finance_platform/models/index.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

// Dark premium palette constants (local to avoid repetition)
const _bg = Color(0xFF050D1F);
const _surface = Color(0xFF091428);
const _card = Color(0xFF0D1E3C);
const _border = Color(0xFF1A3A6B);
const _textMuted = Color(0xFF8BA3C9);
const _blue = Color(0xFF2979FF);
const _cyan = Color(0xFF00E5FF);
const _gold = Color(0xFFFFB300);
const _green = Color(0xFF00C853);

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFinanceData());
  }

  void _loadFinanceData() {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid != null) context.read<FinanceProvider>().loadFinanceData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: Consumer2<FinanceProvider, AuthProvider>(
        builder: (context, finance, auth, _) {
          if (finance.isLoading) {
            return const Center(
              child: LoadingIndicator(showLogo: true, message: 'Loading your data...'),
            );
          }

          if (finance.currentFinanceData == null) {
            return _buildEmptyState(context);
          }

          final data = finance.currentFinanceData!;
          final firstName =
              (auth.currentUser?.name ?? 'there').split(' ').first;

          return RefreshIndicator(
            color: _blue,
            backgroundColor: _surface,
            onRefresh: () async => _loadFinanceData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreetingCard(firstName: firstName, data: data),
                  const SizedBox(height: 12),

                  // Quick nav row
                  _QuickNavRow(data: data),
                  const SizedBox(height: 16),

                  // Income / Expenses
                  Row(children: [
                    Expanded(child: _MetricCard(
                      label: 'Income',
                      value: Formatters.formatCurrency(data.income),
                      icon: Icons.trending_up_rounded,
                      iconBg: const Color(0xFF00391A),
                      iconColor: _green,
                      valueSuffix: '/ mo',
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _MetricCard(
                      label: 'Expenses',
                      value: Formatters.formatCurrency(data.expenses),
                      icon: Icons.trending_down_rounded,
                      iconBg: const Color(0xFF3A1500),
                      iconColor: const Color(0xFFFF6D00),
                      valueSuffix: '/ mo',
                    )),
                  ]),
                  const SizedBox(height: 12),

                  // Goal / Risk
                  Row(children: [
                    Expanded(child: _MetricCard(
                      label: 'Savings Goal',
                      value: Formatters.formatCurrency(data.goalAmount),
                      icon: Icons.track_changes_rounded,
                      iconBg: const Color(0xFF0D2552),
                      iconColor: _blue,
                      valueSuffix: Formatters.getDurationText(data.months),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _MetricCard(
                      label: 'Risk Level',
                      value: data.riskLevel,
                      icon: Icons.shield_rounded,
                      iconBg: _riskBg(data.riskLevel),
                      iconColor: _riskColor(data.riskLevel),
                      valueSuffix: 'Age ${data.age}',
                    )),
                  ]),
                  const SizedBox(height: 12),

                  // Monthly savings target
                  _SavingsTargetCard(data: data),
                  const SizedBox(height: 12),

                  // Savings health
                  _SavingsHealthCard(data: data),
                  const SizedBox(height: 12),

                  // Expense vs savings chart
                  _ExpenseChartCard(data: data),
                  const SizedBox(height: 20),

                  // AI Recommendations button
                  PrimaryButton(
                    label: 'Get AI Recommendations',
                    icon: Icons.auto_awesome_rounded,
                    onPressed: () => _showAISheet(context, finance),
                  ),
                  const SizedBox(height: 10),

                  Row(children: [
                    Expanded(child: SecondaryButton(
                      label: 'Update Info',
                      icon: Icons.edit_rounded,
                      onPressed: () => Navigator.pushNamed(
                          context, AppConstants.financeFormRoute),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: SecondaryButton(
                      label: 'Analysis',
                      icon: Icons.bar_chart_rounded,
                      onPressed: () => _showAnalysisSheet(context, finance),
                    )),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FinanceAILogo(size: 28),
          const SizedBox(width: 10),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFF82B1FF), Colors.white],
            ).createShader(b),
            child: const Text(
              'Finance AI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: const Icon(Icons.refresh_rounded, color: _textMuted, size: 16),
          ),
          onPressed: _loadFinanceData,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  color: _textMuted, size: 16),
            ),
            onPressed: () =>
                Navigator.pushNamed(context, AppConstants.notificationsRoute),
          ),
        ),
      ],
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
                border: Border.all(color: _border),
                boxShadow: [
                  BoxShadow(
                    color: _blue.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: _blue, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Financial Data Yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add your financial details to get\nAI-powered insights and recommendations.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textMuted, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Get Started',
              icon: Icons.add_rounded,
              onPressed: () =>
                  Navigator.pushNamed(context, AppConstants.financeFormRoute),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom nav ──────────────────────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: NavigationBar(
        backgroundColor: _surface,
        selectedIndex: _currentIndex,
        indicatorColor: _blue.withOpacity(0.15),
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
          if (i == 1)
            Navigator.pushNamed(
                context, AppConstants.recommendationsRoute);
          if (i == 2)
            Navigator.pushNamed(context, AppConstants.profileRoute);
          if (i == 3)
            Navigator.pushNamed(context, AppConstants.settingsRoute);
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: _textMuted),
            selectedIcon: Icon(Icons.home_rounded, color: _blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined, color: _textMuted),
            selectedIcon:
                Icon(Icons.auto_awesome_rounded, color: _blue),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: _textMuted),
            selectedIcon: Icon(Icons.person_rounded, color: _blue),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: _textMuted),
            selectedIcon: Icon(Icons.settings_rounded, color: _blue),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // ── Risk helpers ────────────────────────────────────────────────────────────
  Color _riskBg(String r) {
    if (r == 'High') return const Color(0xFF3A0D0D);
    if (r == 'Medium') return const Color(0xFF2D1E00);
    return const Color(0xFF003918);
  }

  Color _riskColor(String r) {
    if (r == 'High') return const Color(0xFFCF6679);
    if (r == 'Medium') return const Color(0xFFFFB300);
    return const Color(0xFF00C853);
  }

  // ── AI sheet ────────────────────────────────────────────────────────────────
  void _showAISheet(BuildContext context, FinanceProvider finance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: _border),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        builder: (ctx, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: _blue, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AI Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              const Text(
                'Personalised advice based on your financial profile',
                style: TextStyle(color: _textMuted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Consumer<FinanceProvider>(
                builder: (_, provider, __) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: LoadingIndicator(
                            showLogo: true,
                            message: 'Generating recommendations...'),
                      ),
                    );
                  }
                  if (provider.aiRecommendation == null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: PrimaryButton(
                        label: 'Generate AI Advice',
                        icon: Icons.psychology_rounded,
                        onPressed: provider.generateAIRecommendation,
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border),
                    ),
                    child: Text(
                      provider.aiRecommendation!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.65,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Analysis sheet ──────────────────────────────────────────────────────────
  void _showAnalysisSheet(BuildContext context, FinanceProvider finance) {
    final analysis = finance.getExpenseAnalysis();
    final data = finance.currentFinanceData;
    if (data == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: _border),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.92,
        builder: (ctx, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _cyan.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bar_chart_rounded,
                      color: _cyan, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Financial Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // Status banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: data.isHighSpending
                      ? const Color(0xFF3A0D0D)
                      : data.isModerateSpending
                          ? const Color(0xFF2D1E00)
                          : const Color(0xFF003918),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: data.isHighSpending
                        ? const Color(0xFFCF6679).withOpacity(0.4)
                        : data.isModerateSpending
                            ? const Color(0xFFFFB300).withOpacity(0.4)
                            : const Color(0xFF00C853).withOpacity(0.4),
                  ),
                ),
                child: Text(
                  analysis['analysis'] as String? ?? '',
                  style: TextStyle(
                    color: data.isHighSpending
                        ? const Color(0xFFCF6679)
                        : data.isModerateSpending
                            ? const Color(0xFFFFB300)
                            : const Color(0xFF00C853),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Metrics
              _AnalysisRow(label: 'Monthly Income',
                  value: Formatters.formatCurrency(data.income),
                  icon: Icons.arrow_upward_rounded,
                  color: _green),
              _AnalysisRow(label: 'Monthly Expenses',
                  value: Formatters.formatCurrency(data.expenses),
                  icon: Icons.arrow_downward_rounded,
                  color: const Color(0xFFFF6D00)),
              _AnalysisRow(
                  label: 'Net Savings',
                  value: Formatters.formatCurrency(
                      (analysis['remaining'] as double? ?? 0.0)),
                  icon: Icons.savings_rounded,
                  color: _blue),
              _AnalysisRow(
                  label: 'Expense Ratio',
                  value:
                      '${(analysis['expenseRatio'] as double? ?? 0.0).toStringAsFixed(1)}%',
                  icon: Icons.pie_chart_rounded,
                  color: _cyan),
              _AnalysisRow(
                  label: 'Savings Ratio',
                  value:
                      '${(analysis['savingsRatio'] as double? ?? 0.0).toStringAsFixed(1)}%',
                  icon: Icons.percent_rounded,
                  color: _gold),
              _AnalysisRow(
                  label: 'Monthly Savings Target',
                  value: Formatters.formatCurrency(
                      analysis['monthSavings'] as double? ?? 0.0),
                  icon: Icons.track_changes_rounded,
                  color: const Color(0xFF9C27B0)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Greeting card ─────────────────────────────────────────────────────────────
class _GreetingCard extends StatelessWidget {
  final String firstName;
  final FinanceData data;

  const _GreetingCard({required this.firstName, required this.data});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D1E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: _blue.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $firstName',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Your financial overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(children: [
            _stat('Net Savings',
                Formatters.formatCurrency(data.income - data.expenses)),
            const SizedBox(width: 28),
            _stat('Savings Rate',
                '${data.savingsRatio.toStringAsFixed(1)}%'),
            const SizedBox(width: 28),
            _stat('Goal Progress',
                '${data.savingsRatio.clamp(0, 100).toStringAsFixed(0)}%'),
          ]),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ── Metric card ───────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String valueSuffix;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 10),
          Text(label,
              style:
                  const TextStyle(color: _textMuted, fontSize: 11)),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
          Text(valueSuffix,
              style:
                  const TextStyle(color: _textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Monthly savings target ────────────────────────────────────────────────────
class _SavingsTargetCard extends StatelessWidget {
  final FinanceData data;
  const _SavingsTargetCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _blue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.savings_rounded, color: _blue, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Monthly Savings Target',
                style: TextStyle(color: _textMuted, fontSize: 12)),
            Text(
              Formatters.formatCurrency(data.monthlySavings),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('to reach goal',
              style: TextStyle(color: _textMuted, fontSize: 11)),
          Text(
            'in ${Formatters.getDurationText(data.months)}',
            style: const TextStyle(
                color: _blue, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ]),
      ]),
    );
  }
}

// ── Savings health bar ────────────────────────────────────────────────────────
class _SavingsHealthCard extends StatelessWidget {
  final FinanceData data;
  const _SavingsHealthCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final rate = data.savingsRatio.clamp(0.0, 100.0);
    final isGood = rate >= 20;
    final isOk = rate >= 10;
    final barColor =
        isGood ? _green : isOk ? _gold : const Color(0xFFCF6679);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Savings Health',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Text('${rate.toStringAsFixed(1)}% of income',
              style: TextStyle(
                  color: barColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: rate / 100,
            minHeight: 8,
            backgroundColor: _card,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isGood
              ? 'Excellent! You\'re saving more than 20% of your income.'
              : isOk
                  ? 'Good progress. Aim for 20%+ savings rate.'
                  : 'Try to cut expenses to improve your savings.',
          style: const TextStyle(color: _textMuted, fontSize: 12, height: 1.5),
        ),
      ]),
    );
  }
}

// ── Expense chart ─────────────────────────────────────────────────────────────
class _ExpenseChartCard extends StatelessWidget {
  final FinanceData data;
  const _ExpenseChartCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final expR = data.expenseRatio.clamp(0.0, 100.0);
    final savR = (100.0 - expR).clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Expense vs Savings',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(children: [
          SizedBox(
            height: 150,
            width: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 36,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFFFF6D00),
                    value: expR,
                    title: '${expR.toStringAsFixed(0)}%',
                    radius: 46,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                  PieChartSectionData(
                    color: _green,
                    value: savR,
                    title: '${savR.toStringAsFixed(0)}%',
                    radius: 46,
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              _legend(
                  label: 'Expenses',
                  value: Formatters.formatCurrency(data.expenses),
                  color: const Color(0xFFFF6D00)),
              const SizedBox(height: 14),
              _legend(
                  label: 'Savings',
                  value: Formatters.formatCurrency(data.income - data.expenses),
                  color: _green),
            ]),
          ),
        ]),
      ]),
    );
  }

  Widget _legend({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ]),
    ]);
  }
}

// ── Analysis row ──────────────────────────────────────────────────────────────
class _AnalysisRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalysisRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: const TextStyle(color: _textMuted, fontSize: 13)),
        ),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

// ── Quick nav row (shown below greeting card) ─────────────────────────────────
class _QuickNavRow extends StatelessWidget {
  final dynamic data;
  const _QuickNavRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _QuickNavCard(
          icon: Icons.auto_awesome_rounded,
          label: 'AI Insights',
          sub: 'Investments & tips',
          color: _blue,
          onTap: () => Navigator.pushNamed(
              context, AppConstants.recommendationsRoute),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _QuickNavCard(
          icon: Icons.notifications_rounded,
          label: 'Notifications',
          sub: 'Alerts & reminders',
          color: _cyan,
          onTap: () => Navigator.pushNamed(
              context, AppConstants.notificationsRoute),
        ),
      ),
    ]);
  }
}

class _QuickNavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;

  const _QuickNavCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            Text(sub,
                style:
                    const TextStyle(color: _textMuted, fontSize: 10)),
          ]),
        ]),
      ),
    );
  }
}
