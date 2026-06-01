# Quick Start Guide

Get the AI Finance Platform running in 5 minutes!

## 🚀 5-Minute Setup

### 1. Prerequisites Check
```bash
flutter --version  # Should be 3.13+
dart --version     # Should be 3.0+
```

### 2. Install Dependencies
```bash
cd "ai-finance-platform"
flutter pub get
```

### 3. Set Environment Variables
```bash
# Copy and create .env file
cp .env.example .env

# Edit .env with your API keys
# OPENAI_API_KEY=your_key_here
# ALPHA_VANTAGE_API_KEY=your_key_here
```

### 4. Firebase Configuration
```bash
# Generate firebase configuration
flutterfire configure
# Select platforms when prompted
```

### 5. Run App
```bash
flutter run
```

## 🔑 Required API Keys

Get these free API keys:

### OpenAI API
1. Visit: https://platform.openai.com/api-keys
2. Create new secret key
3. Add to `.env`: `OPENAI_API_KEY=sk-...`

### Alpha Vantage API
1. Visit: https://www.alphavantage.co/api/
2. Enter email and get API key
3. Add to `.env`: `ALPHA_VANTAGE_API_KEY=...`

### Firebase (Local Testing Only)
For local development, use test mode (no API keys needed).

## 📱 Test Credentials

Use these to test the app:

```
Email: test@example.com
Password: Test@123
```

Or create your own account during signup.

## 🎯 First App Run Walkthrough

1. **Splash Screen** (3 seconds)
   - Loads and checks authentication

2. **Sign Up** (First time)
   - Create account with email/password
   - Set your name

3. **Finance Form**
   - Enter income (e.g., ₹50,000)
   - Enter expenses (e.g., ₹30,000)
   - Set age (e.g., 25)
   - Set savings goal (e.g., ₹100,000)
   - Set duration in months (e.g., 12)
   - Select risk level

4. **Dashboard**
   - View financial overview
   - See expense vs savings pie chart
   - Get AI recommendations

5. **More Features**
   - Profile: Edit user info
   - Settings: Toggle dark mode
   - Charts: View financial analytics

## 🛠️ Common Commands

```bash
# Clean build
flutter clean && flutter pub get

# Run with debug logs
flutter run -v

# Build APK for testing
flutter build apk --debug

# Build release APK
flutter build apk --release

# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
```

## 📂 Project Structure

```
lib/
├── main.dart              # App entry
├── screens/               # UI pages
├── widgets/               # Reusable components
├── providers/             # State management
├── services/              # API & Firebase
├── agents/                # AI agents
├── models/                # Data models
├── utils/                 # Helpers
└── config/                # Configuration
```

## ⚡ Feature Overview

### ✅ Working Features
- Authentication (Sign up, Sign in, Forgot password)
- Finance data input and storage
- Dashboard with charts
- AI-powered recommendations
- Profile management
- Settings (dark mode, notifications)
- Expense analysis
- Risk assessment
- Investment suggestions
- Savings planning

### 🔄 Coming Soon
- Stock market real-time data
- Advanced portfolio tracking
- Budget alerts
- Monthly notifications
- Investment history

## 🐛 Troubleshooting

### App won't run
```bash
# Fix: Clean and rebuild
flutter clean
rm -rf pubspec.lock
flutter pub get
flutter run
```

### API keys not working
```bash
# Check .env file exists in project root
ls -la .env

# Verify format
cat .env

# Restart app after adding keys
```

### Firebase errors
```bash
# Reconfigure Firebase
flutterfire configure --overwrite

# Check google-services.json exists
ls -la android/app/google-services.json
```

### Build errors
```bash
# Update Flutter
flutter upgrade

# Get latest dependencies
flutter pub upgrade

# Clean and rebuild
flutter clean && flutter pub get && flutter run
```

## 📚 Documentation

- **README.md** - Full project documentation
- **FIREBASE_SETUP.md** - Firebase configuration guide
- **API_SETUP.md** - API keys and configuration
- **DEPLOYMENT.md** - Build and deployment guide

## 🎓 Learning Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture)
- [OpenAI API Guide](https://platform.openai.com/docs)

## 💡 Next Steps

1. **Customize UI**
   - Edit colors in `constants.dart`
   - Modify theme in `theme_provider.dart`
   - Add your logo

2. **Add More Features**
   - Budget categories
   - Recurring transactions
   - Export reports
   - Multi-currency support

3. **Deploy**
   - Follow DEPLOYMENT.md
   - Generate release APK
   - Submit to Play Store/App Store

4. **Monitor**
   - Enable Firebase Analytics
   - Set up Crashlytics
   - Monitor API usage

## 🚀 Production Checklist

Before deploying:
- [ ] Update app version in pubspec.yaml
- [ ] Test all screens
- [ ] Verify API integration
- [ ] Check database rules
- [ ] Enable Firebase production mode
- [ ] Generate signed APK/AAB
- [ ] Test on multiple devices
- [ ] Check app size
- [ ] Update version code
- [ ] Create release notes

## 📞 Support

- Check documentation files
- Review source code comments
- Check error logs: `flutter logs`
- Search GitHub issues
- Ask in Flutter community

## 🎉 You're All Set!

The app is ready to use. Start exploring and building!

**Happy coding!**

---

For detailed setup, see:
- [README.md](README.md) - Full documentation
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Firebase guide
- [API_SETUP.md](API_SETUP.md) - API configuration
- [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment guide
