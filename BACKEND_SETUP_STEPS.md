# Complete Backend & API Setup Guide

**Follow these steps in order. Each step is essential.**

---

## 🔥 PART 1: FIREBASE BACKEND SETUP

### Step 1️⃣: Create Firebase Project

1. Open browser → Go to **https://console.firebase.google.com**
2. Click **"Add project"**
3. Enter name: `AI Finance Platform` (or any name you prefer)
4. Click **Continue**
5. Disable **Google Analytics** (optional, click Continue)
6. Click **"Create project"**
7. **Wait 1-2 minutes** for Firebase to create project
8. When done, click **"Continue"**

### Step 2️⃣: Add Your Flutter App to Firebase

1. In Firebase Console, look for **Flutter icon** (bottom of screen or in "Get started" section)
2. Click **Flutter**
3. Enter your **Package name**:
   - **Android**: `com.example.ai_finance_platform`
   - **iOS**: `com.example.aiFinancePlatform`
4. Click **"Register app"**
5. **DO NOT download files yet** - skip to next step

### Step 3️⃣: Run FlutterFire Configure

This command will automatically set everything up.

**Open Terminal/PowerShell:**

```bash
cd "c:\Users\kgeet\OneDrive\Desktop\VS Code Files and webs\Ai finance platform"
```

**Install FlutterFire CLI (first time only):**
```bash
dart pub global activate flutterfire_cli
```

**Configure your Firebase project:**
```bash
flutterfire configure
```

**You'll be asked:**
- Select Firebase project → Choose your project
- Select platforms → Select **Android** and **iOS** (or just Android for now)
- Wait for configuration...

**Result**: File `lib/firebase_options.dart` will be created automatically ✅

### Step 4️⃣: Enable Firebase Authentication

1. In Firebase Console, click **"Authentication"** (left sidebar)
2. Click **"Get started"**
3. Look for **"Email/Password"** option
4. Click on it
5. Toggle **"Enable"** to ON
6. Click **"Save"**

✅ **Authentication enabled!**

### Step 5️⃣: Create Firestore Database

1. In Firebase Console, click **"Firestore Database"** (left sidebar)
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
4. Select region: **"asia-south1"** (or closest to you) or **"us-central1"**
5. Click **"Create"**
6. **Wait 1-2 minutes** for database creation...

✅ **Database created!**

### Step 6️⃣: Set Up Security Rules

1. In Firestore, click **"Rules"** tab (next to Data tab)
2. Delete all existing code
3. **Copy and paste this code:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - only user can access their data
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Finance data - only user can access
    match /finance_data/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
    
    // Recommendations - only user can access
    match /recommendations/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
    
    // Notifications - only user can access
    match /notifications/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
    
    // Investment history - only user can access
    match /investment_history/{document=**} {
      allow read, write: if request.auth.uid == resource.data.uid;
      allow create: if request.auth.uid == request.resource.data.uid;
    }
  }
}
```

4. Click **"Publish"**
5. Click **"Publish"** again to confirm

✅ **Security rules set!**

### Step 7️⃣: Enable Cloud Messaging (Notifications)

1. Click **"Cloud Messaging"** (left sidebar)
2. Note down:
   - **Sender ID** (you'll see it)
   - **Server API Key** (click 3 dots if needed)
3. Keep these for later

✅ **Cloud Messaging enabled!**

---

## 🔑 PART 2: GET API KEYS

### Step 8️⃣: Get OpenAI API Key

1. Open new browser tab → Go to **https://platform.openai.com/api-keys**
2. If not logged in, click **"Sign in"** and log in with your account
3. Click **"Create new secret key"**
4. Give it name: `Finance App`
5. Click **"Create secret key"**
6. **COPY the key** (you'll only see it once!)
7. Save it somewhere safe temporarily

**Your key looks like**: `sk-proj-abc123def456...`

### Step 9️⃣: Get Alpha Vantage API Key

1. Open new browser tab → Go to **https://www.alphavantage.co/api/**
2. Scroll down to **"Get a free API key"**
3. Enter your **email address**
4. Click **"GET FREE API KEY"**
5. Check your email (check spam folder too!)
6. Click link in email
7. You'll see your API key
8. **COPY the key** and save temporarily

**Your key looks like**: `abc123def456ghi789...`

---

## 📝 PART 3: CREATE .env FILE

### Step 🔟: Create .env File in Your Project

1. **Open your project folder:**
```
c:\Users\kgeet\OneDrive\Desktop\VS Code Files and webs\Ai finance platform
```

2. **Create a new file named `.env`** (exactly this name, with the dot)

3. **Open it in VS Code and add:**

```
OPENAI_API_KEY=your_openai_key_here
ALPHA_VANTAGE_API_KEY=your_alpha_vantage_key_here
```

4. **Replace with your actual keys:**
   - Replace `your_openai_key_here` with the OpenAI key you copied
   - Replace `your_alpha_vantage_key_here` with the Alpha Vantage key you copied

**Example (DO NOT use these, get your own):**
```
OPENAI_API_KEY=sk-proj-abc123def456ghi789jkl
ALPHA_VANTAGE_API_KEY=abc123def456ghi789
```

5. **Save the file** (Ctrl+S)

⚠️ **IMPORTANT**: This file should NEVER be committed to Git. It's already in .gitignore ✅

---

## ✅ PART 4: VERIFICATION CHECKLIST

Complete these steps to verify everything is set up:

### Check 1: Firebase Configuration
```bash
# In your project folder, check this file exists:
# lib/firebase_options.dart
```
✅ File should exist after flutterfire configure

### Check 2: Environment File
```bash
# Check .env file exists in project root:
# Should be at: c:\Users\kgeet\OneDrive\Desktop\VS Code Files and webs\Ai finance platform\.env
```
✅ File should have your API keys

### Check 3: Firebase Console
1. Go to **Firebase Console**
2. Check:
   - ✅ Authentication tab shows "Email/Password" enabled
   - ✅ Firestore Database shows status "Ready"
   - ✅ Security Rules are published

### Check 4: Test Firestore Connection
1. In Firebase Console → **Firestore Database** → **Data** tab
2. Create test collection (optional):
   - Click **"Start a collection"**
   - Name: `test`
   - Auto-generate document ID
   - Add field: `message: "test"`
   - Save

✅ Can create documents = connected!

---

## 🧪 PART 5: RUN YOUR APP

### Step 1️⃣1️⃣: Install Dependencies

```bash
cd "c:\Users\kgeet\OneDrive\Desktop\VS Code Files and webs\Ai finance platform"
flutter pub get
```

Wait for it to finish (2-5 minutes)

### Step 1️⃣2️⃣: Clean Build

```bash
flutter clean
flutter pub get
```

### Step 1️⃣3️⃣: Run the App

```bash
flutter run
```

The app will:
1. Compile code
2. Install on device/emulator
3. Show **Splash Screen** (3 seconds)
4. Show **Sign Up Screen**

✅ **If you see Sign Up screen = SUCCESS!**

---

## 🎯 PART 6: TEST THE APP

### Test 1: Create Account
1. Go to **Sign Up screen**
2. Enter:
   - Name: `John Doe` (any name)
   - Email: `test@example.com` (any email)
   - Password: `Test@123` (must be 6+ chars)
   - Confirm: `Test@123`
3. Click **"Sign Up"**

**Expected**: Should redirect to **Finance Form screen**

### Test 2: Enter Financial Data
1. Fill the form:
   - Monthly Income: `50000`
   - Monthly Expenses: `30000`
   - Your Age: `25`
   - Savings Goal: `500000`
   - Months: `12`
   - Risk Level: `Medium`
2. Click **"Submit"**

**Expected**: 
- Data saves to Firestore ✅
- Redirects to **Dashboard**
- Shows expense pie chart

### Test 3: Check Firebase Database
1. Open **Firebase Console** → **Firestore Database** → **Data tab**
2. Look for collections:
   - `users` collection should have your user
   - `finance_data` collection should have your data

✅ **If data appears = Backend connected!**

### Test 4: Get AI Recommendations
1. In app, go to **Dashboard**
2. Scroll down, see **"AI Recommendations"** section
3. Should show financial analysis

✅ **If recommendations appear = OpenAI API working!**

---

## 🚨 TROUBLESHOOTING

### Problem: "Firebase not initialized"
**Solution:**
```bash
flutter clean
flutter pub get
flutterfire configure --overwrite
flutter run
```

### Problem: ".env file not found"
**Solution:**
1. Verify `.env` exists in project root
2. File should be at the root level (same level as pubspec.yaml)
3. Name must be exactly `.env` (with dot)
4. Restart app after creating

### Problem: "API key invalid"
**Solution:**
1. Check `.env` file has correct key
2. Make sure key is not truncated
3. No extra spaces: `OPENAI_API_KEY=sk-...` (no spaces around =)
4. Restart app

### Problem: "Firestore permission denied"
**Solution:**
1. Check Security Rules are published
2. Make sure user is authenticated (signed in)
3. Verify uid in Firestore matches authenticated user
4. Check Rules syntax (no typos)

### Problem: "Flutter command not found"
**Solution:**
```bash
# Add Flutter to PATH:
# Go to: c:\Users\kgeet\AppData\Local\Google\Flutter\bin
# Copy full path
# Add to Windows Environment Variables

# Then restart terminal and try again
flutter --version
```

---

## 📊 WHAT YOU NOW HAVE

| Component | Status |
|-----------|--------|
| Firebase Project | ✅ Created |
| Authentication | ✅ Enabled |
| Firestore Database | ✅ Created |
| Security Rules | ✅ Published |
| Cloud Messaging | ✅ Enabled |
| OpenAI API Key | ✅ Obtained |
| Alpha Vantage API Key | ✅ Obtained |
| .env File | ✅ Created |
| Flutter App | ✅ Running |

---

## 🎉 NEXT STEPS

After this setup:

1. **Test all features** (as shown in Part 6)
2. **Read data in Firestore** to verify it's saving
3. **Try AI recommendations** to test OpenAI integration
4. **Build APK** when ready to deploy (see DEPLOYMENT.md)

---

## 📚 QUICK REFERENCE

| Task | Command |
|------|---------|
| Install dependencies | `flutter pub get` |
| Clean build | `flutter clean` |
| Run app | `flutter run` |
| Check errors | `flutter run -v` |
| Rebuild Flutter | `flutterfire configure --overwrite` |
| Format code | `dart format lib/` |
| Analyze code | `flutter analyze` |

---

## ✉️ NEED HELP?

- **Firebase**: https://firebase.google.com/support
- **OpenAI**: https://help.openai.com
- **Alpha Vantage**: https://www.alphavantage.co/support
- **Flutter**: https://flutter.dev/docs

---

**You're all set! Follow these steps exactly and your app will work perfectly! 🚀**
