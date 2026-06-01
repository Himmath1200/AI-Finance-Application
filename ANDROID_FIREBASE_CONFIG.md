# Firebase Configuration for Android - google-services.json

## 📍 Where to Place Firebase Files

Your Firebase configuration file goes here:
```
android/app/google-services.json  ← Place it HERE
```

## 🔑 Step-by-Step: Get Your Google Services JSON

### Step 1: Go to Firebase Console
1. Open: **https://console.firebase.google.com**
2. Select your project: **"AI Finance Platform"**

### Step 2: Add Android App (if not already done)
1. Click the **gear icon** (⚙️) → **Project settings**
2. Scroll to **"Your apps"** section
3. Look for **Android icon** 📱
4. If you see Android app, skip to Step 3
5. If no Android app yet:
   - Click **"Add app"** button
   - Select **Android** icon
   - Fill in:
     - Android package name: `com.example.ai_finance_platform`
     - App nickname: `AI Finance Platform Android` (optional)
     - Debug signing certificate SHA-1: (optional for now, click "Register app")

### Step 3: Download google-services.json
1. In Firebase Console → **Project settings** → **"Your apps"**
2. Click your **Android app**
3. Look for **"google-services.json"** button
4. Click **"Download google-services.json"**
5. File will be downloaded to your **Downloads** folder

### Step 4: Place File in Your Project

**Option A: Manual Copy**
1. The downloaded file is: `google-services.json`
2. Copy it to: `android/app/google-services.json`
3. The file path should be:
   ```
   c:\Users\kgeet\OneDrive\Desktop\VS Code Files and webs\Ai finance platform\android\app\google-services.json
   ```

**Option B: Using VS Code**
1. Open VS Code in your project
2. Right-click on `android/app` folder
3. Select **"Reveal in File Explorer"**
4. Paste `google-services.json` there
5. Done!

## ✅ Verify Placement

After placing the file, check:
```
android/
└── app/
    ├── build.gradle         ✅
    └── google-services.json ✅ (should be here)
```

## 📝 What's in google-services.json?

The file contains your Firebase project information:
- Project ID
- API keys
- Database URL
- App authentication info

**Example format** (you'll get actual values):
```json
{
  "type": "service_account",
  "project_id": "ai-finance-platform-xxxxx",
  "private_key_id": "xxxxx",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...",
  "client_email": "firebase-adminsdk-xxxxx@ai-finance-platform-xxxxx.iam.gserviceaccount.com",
  "client_id": "xxxxx",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/..."
}
```

## 🚀 After Placing the File

1. **Clean and rebuild:**
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

2. **If you see errors:**
   - Verify file is at `android/app/google-services.json`
   - Make sure filename is exactly `google-services.json` (lowercase)
   - Restart VS Code
   - Run `flutter clean` again

## 🔗 For iOS Users

iOS needs a similar file called `GoogleService-Info.plist`:
```
ios/Runner/GoogleService-Info.plist  ← For iOS
```

Steps:
1. Firebase Console → Project settings → iOS app
2. Download `GoogleService-Info.plist`
3. Place in `ios/Runner/` folder

## 🆘 Troubleshooting

### Error: "google-services.json not found"
**Solution:** File is not in `android/app/` folder
- Verify path: `c:\Users\kgeet\OneDrive\Desktop\VS Code Files and webs\Ai finance platform\android\app\google-services.json`
- File must be at root of `app` folder, not nested deeper

### Error: "Invalid google-services.json"
**Solution:** File is corrupted or wrong package name
- Re-download from Firebase Console
- Verify you selected correct Android app
- Check package name matches: `com.example.ai_finance_platform`

### Build still fails
**Solution:** 
1. Delete entire `android/.gradle` folder
2. Run: `flutter clean`
3. Run: `flutter pub get`
4. Run: `flutter build apk --debug -v` (verbose mode to see errors)

## 📋 Complete Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase
- [ ] `google-services.json` downloaded
- [ ] File placed in `android/app/`
- [ ] build.gradle has Firebase dependencies
- [ ] `.gitignore` prevents committing google-services.json (check: `google-services.json` is in .gitignore)

## 🔐 Security Note

**⚠️ Never commit google-services.json to Git!**
- It contains private Firebase keys
- Check your `.gitignore` includes: `google-services.json`
- If accidentally committed, regenerate the keys in Firebase Console

## 📚 Firebase Project Info Location

Your Firebase project info is here:
- **Project ID**: Firebase Console → Settings → General
- **Package Name**: Firebase Console → Settings → Your apps → Android
- **API Key**: google-services.json → `"api_key"` field

## ✨ Next Steps

1. Place `google-services.json` in `android/app/`
2. Run: `flutter clean && flutter pub get`
3. Build: `flutter build apk --debug`
4. Test: `flutter run`

---

**Once file is placed correctly, your Firebase connection will work!** ✅
