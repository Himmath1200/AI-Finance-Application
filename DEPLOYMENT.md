# Project Deployment Guide

Complete deployment guide for Android APK, iOS, and Web.

## 🤖 Android APK Deployment

### Prerequisites
- Android SDK installed
- Keystore file for signing
- Android 5.0+ target

### Step 1: Generate Keystore (If not already done)
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Step 2: Configure Keystore Reference
Create `android/key.properties`:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

### Step 3: Update Gradle Configuration
Modify `android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 4: Build APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Step 5: Build App Bundle (For Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 6: Test APK
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## 🍎 iOS Deployment

### Prerequisites
- Xcode installed
- Apple Developer account
- Valid development certificates
- iOS 11.0+ minimum

### Step 1: Update iOS Configuration
In `ios/Podfile`:
```ruby
platform :ios, '11.0'
```

In `ios/Runner.xcodeproj`:
- Set Team ID
- Set Bundle ID: `com.example.aiFinancePlatform`

### Step 2: Build for iOS
```bash
flutter build ios --release
```

### Step 3: Archive and Submit (Using Xcode)
```bash
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath build/Runner.xcarchive archive
```

### Step 4: Upload to App Store Connect
1. Open Xcode
2. Organizer → Distribute App
3. Select App Store Connect
4. Sign certificate
5. Submit for review

## 🌐 Web Deployment

### Step 1: Build Web
```bash
flutter build web --release
```

Output: `build/web/`

### Step 2: Firebase Hosting (Recommended)

#### Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
firebase init
```

#### Deploy
```bash
firebase deploy --only hosting
```

### Step 3: Alternative - Manual Hosting

#### Nginx Configuration
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/ai-finance-platform;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /assets {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

#### Deploy Steps
1. Copy `build/web/` to server
2. Configure web server
3. Set up SSL with Let's Encrypt
4. Test all functionality

## 📊 Pre-Deployment Checklist

### Code Quality
- [ ] Remove debug code
- [ ] Remove print statements
- [ ] Check all TODOs
- [ ] Run static analysis: `flutter analyze`
- [ ] Format code: `dart format lib/`

### Configuration
- [ ] Update version in `pubspec.yaml`
- [ ] Remove debug mode in constants
- [ ] Verify all API keys in `.env`
- [ ] Check Firebase configuration
- [ ] Update app name and icon

### Testing
- [ ] Test all authentication flows
- [ ] Verify Firestore operations
- [ ] Test API integrations
- [ ] Check notifications
- [ ] Verify dark mode
- [ ] Test offline functionality
- [ ] Performance testing
- [ ] Device orientation testing

### Security
- [ ] No hardcoded secrets
- [ ] Verify Firestore rules
- [ ] Check API rate limits
- [ ] Verify SSL certificates
- [ ] Review user permissions
- [ ] Check data encryption

### Performance
- [ ] Run performance profiler
- [ ] Optimize images
- [ ] Check build size
- [ ] Test on low-end devices
- [ ] Check battery usage
- [ ] Monitor memory usage

## 🚀 Release Process

### Version Management
Update `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

### Release Notes Template
```
Version 1.0.0 - Initial Release

Features:
- AI-powered financial recommendations
- Multi-agent financial analysis
- Real-time stock market data
- Secure authentication
- Offline support

Bug Fixes:
- Fixed login issue on slow connections
- Improved performance

Known Issues:
- Alpha Vantage API has rate limits on free tier
```

## 📈 Post-Deployment Monitoring

### Metrics to Track
- Daily active users
- Crash rates
- API response times
- User retention
- Feature usage
- Performance metrics

### Tools
- Google Analytics (Firebase)
- Crashlytics
- Performance Monitoring
- Remote Config

### Rollback Procedure
1. Revert to previous version
2. Disable problematic features
3. Deploy hotfix
4. Monitor metrics

## 🐛 Troubleshooting Deployment

### Android Issues

**Issue: Keystore not found**
```bash
# Solution: Check path in key.properties
file ~/upload-keystore.jks
```

**Issue: Version code too high**
```bash
# Solution: Reset in build.gradle
versionCode = 1
```

### iOS Issues

**Issue: Code signing errors**
```bash
# Solution: Reset signing
flutter clean
flutter build ios --release
```

**Issue: Pod installation fails**
```bash
# Solution: Update pods
cd ios
rm Podfile.lock
pod install --repo-update
```

### Web Issues

**Issue: Blank white screen**
- Check browser console for errors
- Verify index.html is correct
- Check CORS settings

**Issue: Assets not loading**
- Verify assets path in pubspec.yaml
- Check web server configuration
- Clear browser cache

## 🔐 Security Checklist

- [ ] All API keys stored securely
- [ ] No credentials in version control
- [ ] SSL/TLS enabled
- [ ] Database rules properly configured
- [ ] Authentication properly implemented
- [ ] Input validation on server
- [ ] Output encoding for web
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] Logging and monitoring enabled

## 📱 Platform-Specific

### Android-Specific
- [ ] Material Design 3
- [ ] Support Android 5.0+
- [ ] Optimize for various screen sizes
- [ ] Test on real devices

### iOS-Specific
- [ ] Support iOS 11.0+
- [ ] iPhone notch support
- [ ] iPad landscape mode
- [ ] Dark mode support

### Web-Specific
- [ ] Responsive design
- [ ] Cross-browser testing
- [ ] PWA configuration
- [ ] SEO optimization

## Useful Commands

```bash
# Clean build
flutter clean

# Check app size
flutter build apk --analyze-size

# Run performance profile
flutter run --profile

# Generate release notes
git log --oneline v1.0.0..HEAD

# Check dependencies
flutter pub outdated

# Update dependencies
flutter pub upgrade
```

## Support & Troubleshooting

For deployment issues:
1. Check [Flutter Deployment Docs](https://flutter.dev/docs/deployment)
2. Review [Firebase Deployment](https://firebase.google.com/docs/hosting/quickstart)
3. Check platform-specific docs
4. Search GitHub issues

---

**Happy Deploying! 🎉**
