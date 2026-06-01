# 🚀 AI Finance Platform

A professional Flutter web application for smart personal finance management powered by AI agents.

## ✨ Key Features

### 🔐 Authentication
- User signup and login with Firebase Auth
- Secure password reset
- Session persistence

### 📊 Dashboard
- Real-time financial overview
- Interactive charts and analytics
- Expense and income tracking
- Savings progress monitoring
- AI-powered risk assessment

### 🤖 AI-Powered Agents
- **Expense Analysis** - Spending pattern insights
- **Risk Assessment** - Investment strategy recommendations
- **Investment Suggestions** - Tailored investment recommendations
- **Savings Planner** - Goal-based savings calculations

### 💰 Financial Tools
- Expense tracker with categories
- Savings goal management
- Monthly financial summary
- Real-time stock market data

## 🌐 Live Demo

**Deploy on Netlify:** See [NETLIFY_DEPLOYMENT.md](NETLIFY_DEPLOYMENT.md)

## 🛠️ Tech Stack

- **Frontend:** Flutter 3.44+
- **State Management:** Provider
- **Backend:** Firebase (Auth, Realtime Database)
- **Charts:** FL Chart
- **APIs:** OpenAI, Alpha Vantage

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase config
├── config/                   # Navigation routing
├── models/                   # Data models
├── services/                 # Business logic
├── agents/                   # AI agents
├── providers/                # State management
├── screens/                  # UI screens
├── widgets/                  # Reusable UI components
└── utils/                    # Utilities & constants
```

## 🚀 Quick Start

### Run Locally
```bash
# Get dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome
```

### Deploy to Netlify
```bash
# Build web app
flutter build web --release

# Deploy (one-click via Netlify UI)
# See NETLIFY_DEPLOYMENT.md for full instructions
```

## 🧪 Testing

See [PHASE_1_TESTING.md](PHASE_1_TESTING.md) for demo testing checklist.

### Manual Testing Checklist
- ✅ Login/Signup flow
- ✅ Dashboard loads correctly
- ✅ Charts render
- ✅ Navigation works
- ✅ Theme toggle (light/dark)
- ✅ Responsive design

## 📱 Browser Support

✅ Chrome  
✅ Firefox  
✅ Edge  
✅ Safari  

## 🏗️ Architecture

```
Presentation Layer (Screens, Widgets)
    ↓
State Management (Provider)
    ↓
Services (Firebase, APIs)
    ↓
Models (Data structures)
```

## 🔑 Key Components

### Screens
- **Splash Screen** - App initialization
- **Auth Screens** - Login, Signup, Password Reset
- **Dashboard** - Financial overview
- **Profile** - User profile management
- **Settings** - App preferences

### Services
- **AuthService** - Firebase authentication
- **RealtimeDatabaseService** - Realtime database operations
- **AIService** - OpenAI integration
- **StockMarketService** - Stock data API

### Providers
- **AuthProvider** - Authentication state
- **FinanceProvider** - Financial data state
- **ThemeProvider** - Theme state (light/dark)

## 🚀 Deployment

### Netlify (Recommended)
1. Go to [netlify.com](https://app.netlify.com)
2. Import this GitHub repository
3. Netlify auto-deploys on every push to `master`

See [NETLIFY_DEPLOYMENT.md](NETLIFY_DEPLOYMENT.md) for detailed instructions.

## 📝 Development Notes

- App uses Firebase Realtime Database (free tier)
- Web deployment uses pre-built Flutter web files
- Firebase configuration is safe (no API keys exposed)
- No .env file needed for web deployment

## 🎯 Next Phases

- Phase 2: Advanced analytics and reports
- Phase 3: Mobile app (iOS/Android)
- Phase 4: Cloud deployment
- Phase 5: Additional AI features

## 📄 License

All rights reserved © 2026

## 👨‍💻 Author

Created for demonstration purposes.

---

**Status:** ✅ Production-Ready  
**Last Updated:** June 1, 2026  
**Version:** 1.0.0
