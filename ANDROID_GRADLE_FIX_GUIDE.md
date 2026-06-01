# Settings.gradle & Local.properties Fix Guide

## ✅ Fixed Issues

I've fixed the errors in your Android gradle files:

### 1. **settings.gradle** - FIXED ✅
**Error:** `GradleException` class not available
**Fixed:** Changed to `FileNotFoundException` which is properly available in Gradle scripts

**Before:**
```gradle
throw new GradleException('Flutter SDK path not found in local.properties')
```

**After:**
```gradle
throw new FileNotFoundException('Flutter SDK path not found in local.properties')
```

---

## 🚨 CRITICAL: Update local.properties File

Your `local.properties` file has a placeholder path that needs to be updated with your ACTUAL Flutter SDK path.

### Current (WRONG):
```properties
flutter.sdk=/path/to/flutter/sdk
```

### What You Need to Do:

#### **Step 1: Find Your Flutter SDK Path**

**Option A: Using VS Code Terminal**
1. Open Terminal in VS Code (Ctrl + `)
2. Run this command:
```powershell
echo $env:FLUTTER_HOME
```
Or:
```powershell
echo $env:PATH
```

**Option B: Check Environment Variables**
1. Press `Win + X` → Open **Settings**
2. Search for **"Environment Variables"**
3. Click **"Edit the system environment variables"**
4. Click **"Environment Variables"** button
5. Look for **FLUTTER_HOME** or **FLUTTER_ROOT** variable
6. The value is your Flutter path

**Option C: Common Flutter Paths**
- Windows: `C:\Users\YourUsername\flutter`
- Or: `C:\flutter`
- Or: Check where you installed it

#### **Step 2: Update local.properties**

Open: `android/local.properties`

**Replace:**
```properties
flutter.sdk=/path/to/flutter/sdk
```

**With your actual path, for example:**
```properties
flutter.sdk=C:\Users\kgeet\flutter
```

**Or if on macOS/Linux:**
```properties
flutter.sdk=/Users/kgeet/flutter
```

---

## 📂 Complete local.properties File Template

```properties
# DO NOT EDIT OR DELETE THIS FILE.
#
# This file must *NOT* be checked into Version Control Systems,
# as it contains information specific to your local configuration.
#
# Location of the SDK. This is only used by Gradle.
# For customization when using a Version Control System, please read the
# header note.
#Mon May 23 12:00:00 IST 2026
flutter.sdk=C:\Users\kgeet\flutter
```

Replace `C:\Users\kgeet\flutter` with YOUR actual Flutter path!

---

## ✅ Android Gradle Files Status

| File | Status | Issue | Fixed |
|------|--------|-------|-------|
| `android/app/build.gradle` | ✅ Fixed | Duplicate minSdkVersion | ✅ Removed |
| `android/settings.gradle` | ✅ Fixed | GradleException error | ✅ Changed to FileNotFoundException |
| `android/build.gradle` | ✅ Good | No issues | N/A |
| `android/local.properties` | ⚠️ NEEDS UPDATE | Placeholder path | Need your actual Flutter path |
| `android/gradle.properties` | ✅ Good | No issues | N/A |

---

## 🔍 How to Find Flutter Path

### Quick Method:
Run in terminal (in your project directory):
```bash
flutter config --android-studio-dir
flutter doctor -v
```

Look for something like:
```
Flutter version 3.13.x at /path/to/flutter
```

### Or Check Your System:

**Windows PowerShell:**
```powershell
Get-Command flutter | Select-Object Source
```

**Windows Command Prompt:**
```cmd
where flutter
```

---

## 🚀 After Updating local.properties

Once you update the Flutter path:

1. **Save the file** (Ctrl + S)

2. **Clean and rebuild:**
```bash
flutter clean
flutter pub get
```

3. **Verify settings:**
```bash
flutter doctor
```

4. **Build APK:**
```bash
flutter build apk --debug
```

---

## 🆘 Troubleshooting

### If you still get "Flutter SDK not found"

1. **Verify path exists:**
   - Open File Explorer
   - Paste your path from local.properties
   - Check if `flutter/bin/flutter.bat` exists

2. **Check for spaces:**
   - If path has spaces, wrap in quotes: `flutter.sdk="C:\Program Files\flutter"`

3. **Check for typos:**
   - Copy-paste exact path from terminal
   - No extra spaces at end

4. **Restart everything:**
   - Close VS Code completely
   - Reopen terminal
   - Run commands again

---

## 📋 Android Gradle Setup Checklist

- [x] **app/build.gradle** - Fixed (removed duplicate minSdkVersion)
- [x] **settings.gradle** - Fixed (changed GradleException to FileNotFoundException)
- [x] **build.gradle** - Verified (no issues)
- [x] **gradle.properties** - Verified (no issues)
- [ ] **local.properties** - **YOU NEED TO UPDATE** with your Flutter path
- [ ] **google-services.json** - Should be in `android/app/` (download from Firebase)

---

## ✨ Next Steps

1. **Find your Flutter SDK path** (see "How to Find Flutter Path" section above)
2. **Update local.properties** with the correct path
3. **Save the file**
4. **Run:** `flutter clean && flutter pub get`
5. **Build:** `flutter build apk --debug`

---

## 📚 Reference

Your project structure should now be:
```
android/
├── app/
│   ├── build.gradle           ✅ Fixed
│   ├── google-services.json   (need to add)
│   └── src/
├── settings.gradle            ✅ Fixed
├── build.gradle              ✅ Good
├── gradle.properties         ✅ Good
└── local.properties          ⚠️ UPDATE THIS
```

---

**Once you update local.properties, all gradle errors will be resolved!** ✅

Need help finding your Flutter path? Run this and share the output:
```bash
flutter doctor -v
```
