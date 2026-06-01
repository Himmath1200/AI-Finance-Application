# API Setup Guide

Setup and configuration guide for all external APIs used in the AI Finance Platform.

## APIs Overview

1. **OpenAI API** - AI recommendations
2. **Alpha Vantage API** - Stock market data

## OpenAI API Setup

### Step 1: Create OpenAI Account
1. Visit [OpenAI Platform](https://platform.openai.com/signup)
2. Sign up or log in
3. Verify email

### Step 2: Create API Key
1. Go to [API Keys](https://platform.openai.com/account/api-keys)
2. Click "Create new secret key"
3. Give it a name (e.g., "Finance App")
4. Copy the key (you won't see it again)

### Step 3: Add to Environment
1. Open `.env` file
2. Add your key:
```
OPENAI_API_KEY=sk-your-key-here
```

### Step 4: Test Connection
Run this in your app to test:
```dart
final aiService = AIService();
final recommendation = await aiService.generateFinancialRecommendation(
  income: 50000,
  expenses: 30000,
  age: 25,
  riskLevel: 'Medium',
  savingsGoal: 100000,
);
print(recommendation);
```

### Step 5: Set Usage Limits (Optional)
1. Go to [Billing/Usage limits](https://platform.openai.com/account/billing/limits)
2. Set a monthly budget
3. Set hard limit to prevent overage

## API Pricing

### OpenAI Pricing
- **GPT-3.5 Turbo**: $0.0005 per 1K input tokens, $0.0015 per 1K output tokens
- **GPT-4**: More expensive
- **Free trial**: $5 credits (expires after 3 months)

**Estimate**: ~50-100 requests per day ≈ $1-5 per month

## Alpha Vantage API Setup

### Step 1: Get Free API Key
1. Visit [Alpha Vantage](https://www.alphavantage.co/api/)
2. Enter your email
3. Receive API key via email

### Step 2: Add to Environment
1. Open `.env` file
2. Add your key:
```
ALPHA_VANTAGE_API_KEY=demo
```
(Use "demo" for testing, replace with your actual key)

### Step 3: Test Connection
```dart
final stockService = StockMarketService();
final stockData = await stockService.getStockData('AAPL');
print(stockData);
```

### Step 4: API Limits
Free tier:
- 5 requests per minute
- 500 requests per day
- Monthly reset: 1st of each month

**Note**: Free API is rate-limited. For production, upgrade to paid plan.

## API Usage in Code

### OpenAI Integration

**In Dashboard**:
```dart
financeProvider.generateAIRecommendation();
```

**In Service**:
```dart
final aiService = AIService();
final recommendation = await aiService.generateFinancialRecommendation(
  income: financeData.income,
  expenses: financeData.expenses,
  age: financeData.age,
  riskLevel: financeData.riskLevel,
  savingsGoal: financeData.goalAmount,
);
```

### Alpha Vantage Integration

**Stock Data**:
```dart
final stockService = StockMarketService();
final data = await stockService.getStockData('AAPL');
```

**Daily Data**:
```dart
final dailyData = await stockService.getDailyData('AAPL');
```

**Search Symbols**:
```dart
final results = await stockService.searchSymbols('Apple');
```

## Environment Variables

### `.env` Template
```
# APIs
OPENAI_API_KEY=your_openai_key_here
ALPHA_VANTAGE_API_KEY=your_alpha_vantage_key_here

# Firebase
FIREBASE_API_KEY=your_firebase_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id

# App Config
APP_NAME=AI Finance Platform
DEBUG_MODE=false
```

### Load in Code
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final openaiKey = dotenv.env['OPENAI_API_KEY'];
final alphaKey = dotenv.env['ALPHA_VANTAGE_API_KEY'];
```

## Error Handling

### API Not Available
The app has fallback behavior when APIs are unavailable:
- **OpenAI**: Returns pre-built recommendations
- **Alpha Vantage**: Returns sample data

### Rate Limiting
- Implemented automatic retry logic
- Waits before retrying
- Shows user-friendly error messages

### Network Issues
- Catches connection timeouts
- Provides offline fallback
- Logs errors for debugging

## Cost Optimization

### Tips to Reduce API Costs
1. **Cache responses**: Store recommendations locally
2. **Batch requests**: Combine multiple requests
3. **Use free tier**: Good for development
4. **Monitor usage**: Check API dashboard regularly
5. **Set limits**: Prevent unexpected charges

## Monitoring & Debugging

### OpenAI
- Dashboard: https://platform.openai.com/account/usage
- Check daily usage
- View cost breakdown

### Alpha Vantage
- Dashboard: https://www.alphavantage.co/api/
- Shows remaining requests
- View API usage stats

### In App
Enable debug logging:
```dart
developer.log('API Call: ${request.url}');
developer.log('Response: ${response.statusCode}');
```

## Troubleshooting

### Issue: 401 Unauthorized
**Causes**:
- Invalid API key
- Expired key
- Wrong environment variable

**Solution**:
- Verify key in console
- Check `.env` file
- Regenerate key if needed

### Issue: 429 Rate Limited
**Causes**:
- Too many requests
- Exceeded monthly quota

**Solution**:
- Implement request throttling
- Add delays between requests
- Upgrade to paid plan

### Issue: 500 Server Error
**Causes**:
- API service down
- Network issue

**Solution**:
- Retry with exponential backoff
- Check service status page
- Show user-friendly error

### Issue: Empty Response
**Causes**:
- Symbol not found
- No data available

**Solution**:
- Validate input parameters
- Check symbol spelling
- Use search functionality

## Production Checklist

- [ ] Remove "demo" from Alpha Vantage key
- [ ] Use production OpenAI key
- [ ] Set API rate limits
- [ ] Enable monitoring
- [ ] Add error logging
- [ ] Set budget alerts
- [ ] Test all edge cases
- [ ] Document API usage
- [ ] Create runbook for issues

## Useful Resources

### Documentation
- [OpenAI API Docs](https://platform.openai.com/docs/api-reference)
- [Alpha Vantage Docs](https://www.alphavantage.co/documentation/)
- [OpenAI Pricing](https://openai.com/pricing)

### Community
- [OpenAI Forum](https://community.openai.com)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/openai-api)

## Support

### OpenAI
- Email: support@openai.com
- Help Center: help.openai.com

### Alpha Vantage
- Email: support@alphavantage.co
- Issues: Check website status

## Common API Response Examples

### OpenAI Response
```json
{
  "choices": [
    {
      "message": {
        "content": "Your recommendation..."
      }
    }
  ]
}
```

### Alpha Vantage Response
```json
{
  "Global Quote": {
    "01. symbol": "AAPL",
    "05. price": "150.25",
    "09. change": "2.50",
    "10. change percent": "1.69%"
  }
}
```

---

For more help, check the main [README.md](README.md)
