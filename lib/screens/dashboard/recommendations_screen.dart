import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_finance_platform/agents/index.dart';
import 'package:ai_finance_platform/models/index.dart';
import 'package:ai_finance_platform/providers/index.dart';
import 'package:ai_finance_platform/widgets/index.dart';
import 'package:ai_finance_platform/utils/index.dart';

const _bg = Color(0xFF050D1F);
const _surface = Color(0xFF091428);
const _card = Color(0xFF0D1E3C);
const _border = Color(0xFF1A3A6B);
const _textMuted = Color(0xFF8BA3C9);
const _blue = Color(0xFF2979FF);
const _cyan = Color(0xFF00E5FF);
const _gold = Color(0xFFFFB300);
const _green = Color(0xFF00C853);
const _red = Color(0xFFCF6679);

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FinanceProvider, AuthProvider>(
      builder: (context, finance, auth, _) {
        final data = finance.currentFinanceData;

        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: _bg,
            elevation: 0,
            title: const Text(
              'AI Insights',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: _blue,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: _textMuted,
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Investments'),
                Tab(text: 'Budget Tips'),
                Tab(text: 'Savings Plan'),
              ],
            ),
          ),
          body: data == null
              ? _NoDataState(
                  onSetup: () => Navigator.pushNamed(
                      context, AppConstants.financeFormRoute))
              : Column(
                  children: [
                    _HealthScoreBar(data: data),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _InvestmentsTab(data: data, finance: finance),
                          _BudgetTipsTab(data: data),
                          _SavingsPlanTab(data: data),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// ── Health Score compact bar ──────────────────────────────────────────────────
class _HealthScoreBar extends StatelessWidget {
  final FinanceData data;
  const _HealthScoreBar({required this.data});

  @override
  Widget build(BuildContext context) {
    final score = _healthScore(data);
    final label = _scoreLabel(score);
    final color = _scoreColor(score);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(children: [
        // Arc score widget
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 5,
              backgroundColor: _card,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeCap: StrokeCap.round,
            ),
            Text(
              '$score',
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(children: [
              Text('Financial Health: ',
                  style:
                      const TextStyle(color: _textMuted, fontSize: 12)),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 6,
                backgroundColor: _card,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ]),
        ),
        const SizedBox(width: 12),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            '$score/100',
            style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }

  static int _healthScore(FinanceData d) {
    int score = 0;
    final savings = d.savingsRatio;
    if (savings >= 20) score += 40;
    else if (savings >= 10) score += 25;
    else if (savings >= 5) score += 10;

    final expense = d.expenseRatio;
    if (expense <= 50) score += 30;
    else if (expense <= 65) score += 20;
    else if (expense <= 80) score += 10;

    final avail = d.income - d.expenses;
    if (avail >= d.monthlySavings) score += 30;
    else if (avail >= d.monthlySavings * 0.5) score += 15;

    return score.clamp(0, 100);
  }

  static String _scoreLabel(int s) {
    if (s >= 80) return 'Excellent';
    if (s >= 60) return 'Good';
    if (s >= 40) return 'Fair';
    return 'Poor';
  }

  static Color _scoreColor(int s) {
    if (s >= 80) return _green;
    if (s >= 60) return _blue;
    if (s >= 40) return _gold;
    return _red;
  }
}

// ── Investments tab ───────────────────────────────────────────────────────────
class _InvestmentsTab extends StatelessWidget {
  final FinanceData data;
  final FinanceProvider finance;
  const _InvestmentsTab({required this.data, required this.finance});

  @override
  Widget build(BuildContext context) {
    final agent = InvestmentSuggestionAgent();
    final available = (data.income - data.expenses).clamp(0, double.infinity);
    final suggestions =
        agent.suggestInvestments(data.riskLevel, available.toDouble());
    final avgReturn = agent.calculateExpectedReturn(suggestions);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Portfolio summary card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF0D1E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('Investable Surplus',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatCurrency(available.toDouble()),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('per month · ${data.riskLevel} Risk Profile',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('Avg Expected Return',
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 4),
              Text(
                '${avgReturn.toStringAsFixed(1)}% p.a.',
                style: const TextStyle(
                    color: _gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ]),
        ),

        const SizedBox(height: 20),

        const Text('RECOMMENDED FOR YOU',
            style: TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5)),
        const SizedBox(height: 12),

        ...suggestions.map((s) => _InvestmentCard(
            suggestion: s, monthlyInvest: available.toDouble() / 3)),

        const SizedBox(height: 20),

        // AI recommendation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _blue.withOpacity(0.3)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _blue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: _blue, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('AI Personalised Advice',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            Consumer<FinanceProvider>(
              builder: (_, prov, __) {
                if (prov.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: _blue, strokeWidth: 2)),
                  );
                }
                if (prov.aiRecommendation != null) {
                  return Text(prov.aiRecommendation!,
                      style: const TextStyle(
                          color: _textMuted,
                          fontSize: 13,
                          height: 1.65));
                }
                return PrimaryButton(
                  label: 'Generate AI Advice',
                  icon: Icons.psychology_rounded,
                  onPressed: prov.generateAIRecommendation,
                );
              },
            ),
          ]),
        ),
      ]),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  final InvestmentSuggestion suggestion;
  final double monthlyInvest;
  const _InvestmentCard(
      {required this.suggestion, required this.monthlyInvest});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconForType(suggestion.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Flexible(
                child: Text(
                  suggestion.type,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: _green.withOpacity(0.3)),
                ),
                child: Text(
                  '${suggestion.expectedReturn}% p.a.',
                  style: const TextStyle(
                      color: _green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(suggestion.description,
                style: const TextStyle(
                    color: _textMuted, fontSize: 12, height: 1.5)),
            const SizedBox(height: 10),
            Row(children: [
              _chip(
                  icon: Icons.currency_rupee_rounded,
                  label:
                      '${Formatters.formatCurrency(monthlyInvest)}/mo',
                  color: _blue),
              const SizedBox(width: 8),
              _chip(
                  icon: Icons.shield_rounded,
                  label: '${suggestion.riskLevel} Risk',
                  color: _riskColor(suggestion.riskLevel)),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _chip(
      {required IconData icon,
      required String label,
      required Color color}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 11),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  static (IconData, Color) _iconForType(String type) {
    if (type.contains('Stock')) return (Icons.show_chart_rounded, _blue);
    if (type.contains('SIP')) return (Icons.loop_rounded, _cyan);
    if (type.contains('Mutual')) return (Icons.pie_chart_rounded, _gold);
    if (type.contains('Bond') || type.contains('Government'))
      return (Icons.account_balance_rounded, _green);
    if (type.contains('Fixed') || type.contains('FD'))
      return (Icons.lock_rounded, const Color(0xFF9C27B0));
    return (Icons.bar_chart_rounded, _blue);
  }

  static Color _riskColor(String r) {
    if (r == 'High') return _red;
    if (r == 'Medium') return _gold;
    return _green;
  }
}

// ── Budget Tips tab ───────────────────────────────────────────────────────────
class _BudgetTipsTab extends StatelessWidget {
  final FinanceData data;
  const _BudgetTipsTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final agent = ExpenseAnalysisAgent();
    final result = agent.analyzeExpenses(data);
    final severity = result['severity'] as String;
    final analysis = result['analysis'] as String;
    final tips = result['recommendations'] as List<String>;

    final (sevColor, sevIcon) = switch (severity) {
      'High' => (_red, Icons.warning_rounded),
      'Moderate' => (_gold, Icons.info_rounded),
      _ => (_green, Icons.check_circle_rounded),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Spending status
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: sevColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: sevColor.withOpacity(0.3)),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Icon(sevIcon, color: sevColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text('Spending Status: ',
                      style: const TextStyle(
                          color: _textMuted, fontSize: 12)),
                  Text(severity,
                      style: TextStyle(
                          color: sevColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 6),
                Text(analysis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.55)),
              ]),
            ),
          ]),
        ),

        const SizedBox(height: 20),

        // Key metrics row
        Row(children: [
          _StatPill(
              label: 'Expense Ratio',
              value:
                  '${data.expenseRatio.toStringAsFixed(1)}%',
              color: sevColor),
          const SizedBox(width: 10),
          _StatPill(
              label: 'Net Surplus',
              value: Formatters.formatCurrency(
                  data.income - data.expenses),
              color: _blue),
        ]),

        const SizedBox(height: 20),

        const Text('ACTION ITEMS',
            style: TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5)),
        const SizedBox(height: 12),

        ...tips.asMap().entries.map((e) => _TipCard(
            index: e.key + 1, tip: e.value, color: sevColor)),

        const SizedBox(height: 20),

        // Expense breakdown
        const Text('EXPENSE BREAKDOWN',
            style: TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5)),
        const SizedBox(height: 12),
        _ExpenseBreakdown(data: data),
      ]),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill(
      {required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(label,
              style:
                  const TextStyle(color: _textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final int index;
  final String tip;
  final Color color;
  const _TipCard(
      {required this.index,
      required this.tip,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Text('$index',
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(tip,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.45)),
        ),
      ]),
    );
  }
}

class _ExpenseBreakdown extends StatelessWidget {
  final FinanceData data;
  const _ExpenseBreakdown({required this.data});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Housing', 0.30, const Color(0xFF2979FF)),
      ('Food & Dining', 0.20, const Color(0xFFFF6D00)),
      ('Transport', 0.15, const Color(0xFF00E5FF)),
      ('Entertainment', 0.12, const Color(0xFF9C27B0)),
      ('Utilities', 0.13, const Color(0xFFFFB300)),
      ('Others', 0.10, const Color(0xFF00C853)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: categories.map((c) {
          final amt = data.expenses * c.$2;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                    color: c.$3, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(c.$1,
                      style: const TextStyle(
                          color: _textMuted, fontSize: 12))),
              Text(Formatters.formatCurrency(amt),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: c.$2,
                    minHeight: 5,
                    backgroundColor: _card,
                    valueColor: AlwaysStoppedAnimation<Color>(c.$3),
                  ),
                ),
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }
}

// ── Savings Plan tab ──────────────────────────────────────────────────────────
class _SavingsPlanTab extends StatelessWidget {
  final FinanceData data;
  const _SavingsPlanTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final agent = GoalSavingsPlannerAgent();
    final plan = agent.planSavings(data);
    final milestones = agent.getMilestones(data);
    final allocation =
        agent.getSavingsByCategory(data.monthlySavings);

    final feasibility = plan['feasibility'] as String;
    final (feasColor, feasIcon) = switch (feasibility) {
      'Achievable' => (_green, Icons.check_circle_rounded),
      'Challenging' => (_gold, Icons.warning_rounded),
      _ => (_red, Icons.cancel_rounded),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Goal overview
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF0D1E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('Savings Goal',
                    style: TextStyle(
                        color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 3),
                Text(Formatters.formatCurrency(data.goalAmount),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: feasColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: feasColor.withOpacity(0.4)),
                ),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Icon(feasIcon, color: feasColor, size: 14),
                  const SizedBox(width: 5),
                  Text(feasibility,
                      style: TextStyle(
                          color: feasColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              _goalStat('Monthly Need',
                  Formatters.formatCurrency(data.monthlySavings)),
              const SizedBox(width: 20),
              _goalStat(
                  'Available',
                  Formatters.formatCurrency(
                      data.income - data.expenses)),
              const SizedBox(width: 20),
              _goalStat('Duration',
                  Formatters.getDurationText(data.months)),
            ]),
            const SizedBox(height: 12),
            Text(plan['recommendation'] as String,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5)),
          ]),
        ),

        const SizedBox(height: 20),

        const Text('MILESTONES',
            style: TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5)),
        const SizedBox(height: 12),

        Row(children: milestones.asMap().entries.map((e) {
          final m = e.value;
          final pct = (m['progressPercentage'] as double).clamp(0, 100);
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: e.key < milestones.length - 1 ? 8 : 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Column(children: [
                Text('${pct.toStringAsFixed(0)}%',
                    style: TextStyle(
                        color: _milestoneColor(e.key),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Mo ${m['month']}',
                    style: const TextStyle(
                        color: _textMuted, fontSize: 10)),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatCompactNumber(
                      m['targetAmount'] as double),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ]),
            ),
          );
        }).toList()),

        const SizedBox(height: 20),

        const Text('MONTHLY ALLOCATION',
            style: TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5)),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: allocation.entries
                .toList()
                .asMap()
                .entries
                .map((e) {
              final colors = [_blue, _cyan, _gold, _green];
              final c = colors[e.key % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(e.value.key,
                          style: const TextStyle(
                              color: _textMuted, fontSize: 13))),
                  Text(Formatters.formatCurrency(e.value.value),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ]),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Widget _goalStat(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style:
              const TextStyle(color: Colors.white54, fontSize: 10)),
      const SizedBox(height: 2),
      Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold)),
    ]);
  }

  Color _milestoneColor(int i) {
    const colors = [_textMuted, _blue, _cyan, _green];
    return colors[i % colors.length];
  }
}

// ── No data state ─────────────────────────────────────────────────────────────
class _NoDataState extends StatelessWidget {
  final VoidCallback onSetup;
  const _NoDataState({required this.onSetup});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _surface,
              shape: BoxShape.circle,
              border: Border.all(color: _border),
            ),
            child: const Icon(Icons.psychology_rounded,
                color: _blue, size: 48),
          ),
          const SizedBox(height: 24),
          const Text('No Data to Analyze',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            'Set up your financial details first to unlock\npersonalised AI insights.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textMuted, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Set Up Finances',
            icon: Icons.add_rounded,
            onPressed: onSetup,
          ),
        ]),
      ),
    );
  }
}
