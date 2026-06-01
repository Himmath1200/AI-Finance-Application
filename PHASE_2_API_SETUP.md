# 📱 Phase 2: API Key Generation & Integration

Complete guide for setting up external APIs for AI Finance Platform.

## 🎯 Phase 2 Overview

**Objective:** Integrate external APIs for AI recommendations and stock market data

**APIs Required:**
1. ✅ **OpenAI API** - For AI financial recommendations
2. ✅ **Alpha Vantage API** - For stock market data

**Time:** ~30 minutes for setup

---

## 📋 Step 1: OpenAI API Setup

### 1.1 Create OpenAI Account
1. Go to **https://platform.openai.com**
2. Click **"Sign up"** (top right)
3. Enter your email and create account
4. Verify your email
5. Complete your profile (Name, Organization)

### 1.2 Create API Key
1. Go to **https://platform.openai.com/api/keys**
2. Click **"Create new secret key"** button
3. **IMPORTANT:** Copy the key immediately - you won't see it again!
   ```
   sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
4. Store it safely in your `.env` file

### 1.3 Set Up Billing (Important!)
1. Go to **https://platform.openai.com/account/billing/overview**
2. Click **"Set up paid account"**
3. Add payment method (Credit/Debit card)
4. Set usage limits if desired (to avoid surprise charges)

### 1.4 Check Available Models
- Visit: **https://platform.openai.com/docs/models**
- Recommended model: **gpt-3.5-turbo** (fast & affordable)
- Also available: **gpt-4** (more powerful, costlier)

### 1.5 Test Your Key
```bash
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer sk-proj-YOUR_API_KEY_HERE"
```

---

## 📊 Step 2: Alpha Vantage API Setup

### 2.1 Create Free Account
1. Go to **https://www.alphavantage.co**
2. Scroll to **"Get your free API key"**
3. Enter your email address
4. Click **"GET FREE API KEY"**
5. Check your email for API key
   ```
   API_KEY=XXXXXXXXXX
   ```

### 2.2 API Key Limits (Free Tier)
- ✅ 5 calls per minute
- ✅ 100 calls per day
- ✅ All functions available
- ❌ No historical data caching

### 2.3 Test Your Key
```bash
https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=YOUR_API_KEY_HERE
```

### 2.4 Upgrade to Premium (Optional)
- Visit: **https://www.alphavantage.co/premium/**
- $29.99/month for unlimited calls
- Good for production apps

---

## 🔐 Step 3: Store API Keys Safely

### 3.1 Create .env File
Create `your-project/.env`:
```env
# OpenAI API
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Alpha Vantage API
ALPHA_VANTAGE_API_KEY=XXXXXXXXXX
```

### 3.2 Add to .gitignore (IMPORTANT!)
Make sure `.env` is in your `.gitignore`:
```
# In .gitignore file
.env
.env.local
```

**⚠️ NEVER commit .env to GitHub!**

### 3.3 For Web Deployment
Since web can't access .env files, you'll use environment variables:

**On Netlify:**
1. Go to your site settings
2. **Build & Deploy** → **Environment**
3. Add variables:
   ```
   OPENAI_API_KEY=sk-proj-...
   ALPHA_VANTAGE_API_KEY=...
   ```

---

## 💻 Step 4: Configure in Flutter App

### 4.1 Update pubspec.yaml (if using dotenv)
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

### 4.2 Load in main.dart
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();  // Load .env file
  runApp(const MyApp());
}
```

### 4.3 Use in Services
```dart
// In ai_service.dart
String get _apiKey {
  return dotenv.env['OPENAI_API_KEY'] ?? '';
}

// In stock_market_service.dart
String get _apiKey {
  return dotenv.env['ALPHA_VANTAGE_API_KEY'] ?? 'demo';
}
```

---

## 🧪 Step 5: Test APIs in Flutter

### 5.1 Test OpenAI API
```dart
// In ai_service.dart
final recommendation = await generateFinancialRecommendation(
  income: 50000,
  expenses: 30000,
  age: 30,
  riskLevel: 'medium',
  savingsGoal: 100000,
);
print('AI Recommendation: $recommendation');
```

### 5.2 Test Alpha Vantage API
```dart
// In stock_market_service.dart
final stockData = await getStockPrice('AAPL');
print('Stock Price: ${stockData?['price']}');
```

---

## 📈 Step 6: Implement AI Recommendations

### 6.1 Create Recommendation Agents

#### Expense Analysis Agent
```dart
// lib/agents/expense_analysis_agent.dart
class ExpenseAnalysisAgent {
  final AIService _aiService;
  
  Future<String> analyzeSpending({
    required double totalExpenses,
    required Map<String, double> categories,
  }) async {
    final prompt = '''
    Analyze these monthly expenses:
    Total: \$$totalExpenses
    Categories: $categories
    
    Provide insights on spending patterns.
    ''';
    
    return await _aiService.generateRecommendation(prompt);
  }
}
```

#### Risk Assessment Agent
```dart
// lib/agents/risk_assessment_agent.dart
class RiskAssessmentAgent {
  final AIService _aiService;
  
  Future<String> assessInvestmentRisk({
    required int age,
    required double savingsAmount,
    required String incomeLevel,
  }) async {
    final prompt = '''
    Age: $age
    Savings: \$$savingsAmount
    Income: $incomeLevel
    
    Recommend optimal risk level and investment strategy.
    ''';
    
    return await _aiService.generateRecommendation(prompt);
  }
}
```

#### Investment Suggestion Agent
```dart
// lib/agents/investment_suggestion_agent.dart
class InvestmentSuggestionAgent {
  final AIService _aiService;
  final StockMarketService _stockService;
  
  Future<List<String>> getSuggestions({
    required String riskLevel,
    required double investmentBudget,
  }) async {
    // Fetch stock data
    final stocks = ['AAPL', 'MSFT', 'GOOGL', 'AMZN'];
    
    for (var symbol in stocks) {
      final data = await _stockService.getStockPrice(symbol);
      // Analyze and recommend
    }
    
    return suggestions;
  }
}
```

#### Savings Planner Agent
```dart
// lib/agents/goal_savings_planner_agent.dart
class GoalSavingsPlannerAgent {
  final AIService _aiService;
  
  Future<String> calculateSavingsGoal({
    required double currentSavings,
    required double targetAmount,
    required int monthsToGoal,
  }) async {
    final monthlySavings = (targetAmount - currentSavings) / monthsToGoal;
    
    final prompt = '''
    Current savings: \$$currentSavings
    Goal: \$$targetAmount
    Timeline: $monthsToGoal months
    Required monthly savings: \$$monthlySavings
    
    Create a personalized savings plan.
    ''';
    
    return await _aiService.generateRecommendation(prompt);
  }
}
```

---

## 🔌 Step 7: Add APIs to Dashboard

### 7.1 Update Dashboard Screen
```dart
// lib/screens/dashboard/dashboard_screen.dart
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _aiRecommendation = '';
  String _riskAssessment = '';
  List<String> _investmentSuggestions = [];
  
  @override
  void initState() {
    super.initState();
    _loadAIRecommendations();
  }
  
  Future<void> _loadAIRecommendations() async {
    final finance = context.read<FinanceProvider>();
    
    // Get AI recommendations
    final recommendation = await AIService().generateFinancialRecommendation(
      income: finance.data.income ?? 0,
      expenses: finance.data.expenses ?? 0,
      age: 30,
      riskLevel: finance.data.riskLevel ?? 'medium',
      savingsGoal: finance.data.savingsGoal ?? 0,
    );
    
    setState(() {
      _aiRecommendation = recommendation;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing widgets...
            
            // AI Recommendation Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Recommendations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 12),
                    Text(_aiRecommendation),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ Phase 2 Checklist

- [ ] OpenAI API account created
- [ ] OpenAI API key generated
- [ ] Alpha Vantage API key generated
- [ ] .env file created with both keys
- [ ] .env added to .gitignore
- [ ] API keys configured in Netlify (if deploying)
- [ ] AIService updated with working API key
- [ ] StockMarketService updated with working API key
- [ ] Agents created and implemented
- [ ] Dashboard updated with AI recommendations
- [ ] API calls tested locally
- [ ] App recompiled and tested
- [ ] Changes pushed to GitHub

---

## 🚀 Next Steps

After Phase 2 is complete:

1. **Phase 3:** Implement notification system (FCM)
2. **Phase 4:** Add advanced charts and analytics
3. **Phase 5:** Build Android/iOS native apps
4. **Phase 6:** Deploy to Play Store / App Store

---

## 🆘 Troubleshooting

### Issue: "API key not found"
**Solution:** Make sure `.env` file exists and has correct path

### Issue: "401 Unauthorized"
**Solution:** Check API key is correct and billing is set up (OpenAI)

### Issue: "Rate limit exceeded"
**Solution:** Alpha Vantage free tier has 5 calls/min limit. Wait or upgrade.

### Issue: "CORS error" (Web)
**Solution:** Use server-side proxy or contact API for CORS headers

---

## 📞 API Documentation

- **OpenAI:** https://platform.openai.com/docs/api-reference
- **Alpha Vantage:** https://www.alphavantage.co/documentation/

---

**Status:** Ready for Phase 2 implementation  
**Estimated time:** 2-3 hours for full integration  
**Difficulty:** Moderate
