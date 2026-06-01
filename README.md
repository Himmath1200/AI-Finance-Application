# 🚀 Multi-Agent AI-Based Personal Finance Optimization Platform

A professional, production-ready Flutter application for smart financial planning powered by AI agents and machine learning.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Firebase Setup](#firebase-setup)
- [API Configuration](#api-configuration)
- [Architecture](#architecture)
- [Deployment](#deployment)

## ✨ Features

### 🔐 Authentication
- Email/password login and registration
- Password reset functionality
- Session persistence
- Secure credential storage

### 📊 Dashboard
- Real-time financial overview
- Visual charts and analytics
- Expense tracking
- Savings progress monitoring
- Risk assessment display

### 🤖 AI Agents
- **Expense Analysis Agent**: Analyzes spending patterns and provides recommendations
- **Risk Assessment Agent**: Determines optimal investment strategy based on age and profile
- **Investment Suggestion Agent**: Recommends tailored investment vehicles
- **Goal-Based Savings Planner**: Calculates monthly savings needed to reach goals

### 💰 Financial Management
- Income and expense tracking
- Savings goal management
- Personal savings plan with milestones
- Monthly financial summary

### 📈 Market Data
- Real-time stock market information (via Alpha Vantage API)
- Investment portfolio tracking
- Market trends analysis

### 🔔 Notifications
- Budget exceeded alerts
- Savings goal reminders
- Monthly financial check-ins
- Investment opportunities

### 🎨 UI/UX
- Material Design 3
- Light and dark modes
- Responsive layouts
- Smooth animations
- Professional design

## 🛠️ Tech Stack

### Frontend
- **Flutter** - UI Framework
- **Provider** - State Management
- **fl_chart** - Data Visualization

### Backend Services
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - Database
- **Firebase Cloud Messaging** - Push notifications
- **Firebase Storage** - File storage

### External APIs
- **OpenAI API** - AI recommendations
- **Alpha Vantage API** - Stock market data

### Architecture
- **Clean Architecture** - Modular, scalable structure
- **Repository Pattern** - Data layer separation
- **Service-Oriented** - Reusable business logic
- **Provider Pattern** - State management

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── config/
│   ├── app_router.dart      # Navigation routing
│   └── index.dart           # Config barrel file
├── models/
│   ├── user_model.dart
│   ├── finance_data_model.dart
│   ├── ai_recommendation_model.dart
│   ├── investment_model.dart
│   ├── notification_model.dart
│   └── index.dart           # Models barrel file
├── services/
│   ├── firebase_service.dart     # Firebase operations
│   ├── ai_service.dart           # OpenAI integration
│   ├── stock_market_service.dart  # Alpha Vantage API
│   ├── notification_service.dart  # FCM notifications
│   └── index.dart                # Services barrel file
├── agents/
│   ├── expense_analysis_agent.dart
│   ├── risk_assessment_agent.dart
│   ├── investment_suggestion_agent.dart
│   ├── goal_savings_planner_agent.dart
│   └── index.dart                # Agents barrel file
├── providers/
│   ├── auth_provider.dart
│   ├── finance_provider.dart
│   ├── theme_provider.dart
│   └── index.dart            # Providers barrel file
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   ├── finance_form_screen.dart
│   │   ├── profile_screen.dart
│   │   └── settings_screen.dart
│   └── index.dart            # Screens barrel file
├── widgets/
│   ├── cards.dart            # Card widgets
│   ├── buttons.dart          # Button widgets
│   ├── text_fields.dart      # Input widgets
│   ├── loaders.dart          # Loading & empty states
│   └── index.dart            # Widgets barrel file
├── utils/
│   ├── constants.dart        # App constants
│   ├── validators.dart       # Form validators
│   ├── formatters.dart       # Data formatters
│   ├── extensions.dart       # Dart extensions
│   └── index.dart            # Utils barrel file
└── .env                      # Environment variables
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.13+
- Dart 3.0+
- Firebase project
- OpenAI API key
- Alpha Vantage API key

### Installation

1. **Clone or download the project**
```bash
cd ai-finance-platform
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment variables**
```bash
cp .env.example .env
# Edit .env with your API keys
```

4. **Generate Firebase configuration** (See Firebase Setup section)

5. **Run the app**
```bash
flutter run
```

## 🔥 Firebase Setup

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name: "AI Finance Platform"
4. Enable Google Analytics (optional)
5. Click Create

### Step 2: Add Flutter App
1. In Firebase Console, click the Flutter icon
2. Enter your bundle ID:
   - Android: `com.example.ai_finance_platform`
   - iOS: `com.example.aiFinancePlatform`
3. Download configuration files:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`

### Step 3: Add Configuration Files
- **Android**: Place `google-services.json` in `android/app/`
- **iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`

### Step 4: Enable Authentication
1. In Firebase Console, go to Authentication
2. Click "Sign-in method"
3. Enable "Email/Password"

### Step 5: Create Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Select "Start in test mode"
4. Choose your region
5. Click "Create"

### Step 6: Set Firestore Rules
In Firestore Rules tab, use:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    match /finance_data/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
    }
    match /recommendations/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
    }
    match /notifications/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
    }
  }
}
```

### Step 7: Enable Cloud Messaging
1. Go to Cloud Messaging tab
2. Note the Sender ID

## 🔌 API Configuration

### OpenAI API
1. Go to [OpenAI Platform](https://platform.openai.com)
2. Create an API key
3. Add to `.env`:
```
OPENAI_API_KEY=your_api_key_here
```

### Alpha Vantage API
1. Go to [Alpha Vantage](https://www.alphavantage.co)
2. Get free API key
3. Add to `.env`:
```
ALPHA_VANTAGE_API_KEY=your_api_key_here
```

## 🏗️ Architecture Overview

### Clean Architecture Layers

**Presentation Layer** (Screens & UI)
- `screens/` - UI pages
- `widgets/` - Reusable components
- `providers/` - State management

**Domain Layer** (Business Logic)
- `agents/` - AI agents & business rules
- `models/` - Data models

**Data Layer** (Data Management)
- `services/` - External services & APIs
- Firebase operations

### Data Flow
```
UI (Screens) → Providers → Agents & Services → Firebase/APIs
```

## 🚢 Deployment

### Android APK Build
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS Build
```bash
flutter build ios --release
```

### Web Build
```bash
flutter build web --release
```

### Play Store Deployment
1. Create app bundle:
```bash
flutter build appbundle --release
```
2. Upload to Google Play Console

### App Store Deployment
1. Build for iOS
2. Upload with Xcode or Transporter

## 📱 App Walkthrough

### 1. Splash Screen
- Shows app logo and loading animation
- Checks authentication state
- Auto-redirects to Login or Dashboard

### 2. Authentication Flow
- **Sign Up**: Create account with email/password
- **Sign In**: Login with credentials
- **Forgot Password**: Password reset via email
- **Session Persistence**: Auto-login on app restart

### 3. Finance Form
- Enter monthly income and expenses
- Set savings goal and timeline
- Select risk preference
- AI automatically determines risk level based on age

### 4. Dashboard
- View financial summary cards
- See expense vs savings ratio (pie chart)
- Check monthly savings target
- Get AI recommendations
- Analyze financial situation

### 5. Profile Screen
- Edit user information
- View account details
- Logout functionality

### 6. Settings Screen
- Toggle dark mode
- Enable/disable notifications
- Change currency
- View app version and policies

## 🧠 AI Agents Explained

### Expense Analysis Agent
- Calculates expense ratio
- Determines spending severity (High/Moderate/Good)
- Provides specific recommendations

### Risk Assessment Agent
- Determines risk level (Low/Medium/High)
- Factors: Age, Income, Savings capacity
- Recommends investment horizon

### Investment Suggestion Agent
- Recommends investment types by risk level
- High Risk: 70% Stocks, 20% Bonds, 10% Cash
- Medium Risk: 50% Stocks, 35% Bonds, 15% Cash
- Low Risk: 30% Stocks, 50% Bonds, 20% Cash

### Goal Savings Planner Agent
- Calculates monthly savings needed
- Checks feasibility
- Creates milestone tracking
- Suggests savings breakdown by category

## 🔒 Security

- **No hardcoded API keys** - Uses environment variables
- **Secure authentication** - Firebase Auth
- **Data encryption** - Firebase Firestore rules
- **Session management** - Automatic token refresh
- **Password security** - 6+ character requirement

## 🎯 Key Features Implementation

### Real-time Updates
- Firestore listeners for live data sync
- Provider pattern for state updates
- Auto-refresh on navigation

### Offline Support
- Local data caching (SharedPreferences)
- Works without internet initially
- Syncs when reconnected

### Error Handling
- Try-catch in all services
- User-friendly error messages
- Retry mechanisms

## 📚 Testing

### Manual Testing Checklist
- [ ] User can sign up
- [ ] User can sign in
- [ ] Forgot password works
- [ ] Finance form validates correctly
- [ ] Dashboard displays data
- [ ] AI recommendations generate
- [ ] Profile can be updated
- [ ] Logout works
- [ ] Dark mode toggles
- [ ] Notifications send

## 🐛 Troubleshooting

### Firebase Connection Issues
- Check Google Services JSON/plist files
- Verify Firebase project ID
- Check internet connectivity

### API Key Issues
- Verify `.env` file exists
- Check API keys are correct
- Ensure APIs are enabled in console

### App Crashes
- Check Flutter version: `flutter --version`
- Run: `flutter clean` then `flutter pub get`
- Check logs: `flutter logs`

## 📖 Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Alpha Vantage Docs](https://www.alphavantage.co/documentation)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests.

## 📞 Support

For support, email support@aifinanceplatform.com or open an issue.

---

**Built with ❤️ using Flutter | Made for financial excellence**
