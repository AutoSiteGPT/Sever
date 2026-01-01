# Halt - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Add Required Assets

1. **Download Inter Font**
   - Go to [Google Fonts - Inter](https://fonts.google.com/specimen/Inter)
   - Download the font family
   - Extract and copy these files to `assets/fonts/`:
     - `Inter-Regular.ttf`
     - `Inter-SemiBold.ttf`

2. **Create App Icon** (or use placeholder)
   - Create a 1024x1024 PNG with:
     - White background (#FFFFFF)
     - Black circle in center (#000000)
   - Save as `assets/icon/app_icon.png`
   - Copy same file as `assets/icon/app_icon_foreground.png`

### Step 3: Configure RevenueCat

1. Sign up at [revenuecat.com](https://www.revenuecat.com/)
2. Create a new project
3. Get your API key
4. Open [`lib/services/subscription_service.dart`](lib/services/subscription_service.dart:8)
5. Replace `YOUR_REVENUECAT_API_KEY_HERE` with your actual key
6. Create a product in RevenueCat:
   - Product ID: `halt_pro_annual`
   - Price: $39.99
   - Duration: 1 year

### Step 4: Run on iOS

```bash
# Open Xcode
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select your development team
# 2. Add "Family Controls" capability
# 3. Close Xcode

# Run on device (simulator won't work for FamilyControls)
flutter run -d <your-device-id>
```

### Step 5: Run on Android

```bash
# Run on device or emulator
flutter run -d <your-device-id>

# When app launches:
# 1. Tap "SELECT APPS"
# 2. Choose apps to block
# 3. Tap "START BLOCKING"
# 4. Enable Accessibility Service when prompted
```

## 🎨 Design Specifications

### Colors
```dart
Background:     #000000  // Pure black
Text:           #FFFFFF  // White
Secondary:      #888888  // Gray
Border:         #333333  // Dark gray
```

### Typography
```dart
Font Family:    Inter
Title Weight:   600 (SemiBold)
Body Weight:    400 (Regular)
Letter Spacing: -0.02
```

### Layout Rules
- ❌ No rounded corners
- ❌ No bottom navigation
- ❌ No gradients
- ✅ Pure black background
- ✅ Sharp edges (BorderRadius.zero)
- ✅ Minimal animations

## 🔧 Platform-Specific Setup

### iOS Requirements
- **Xcode 14+**
- **Real device** (FamilyControls doesn't work on simulator)
- **Development team** for signing
- **FamilyControls capability** enabled

### Android Requirements
- **Android Studio** (for building)
- **API Level 24+** (Android 7.0+)
- **Accessibility permission** (granted at runtime)
- **Overlay permission** (granted at runtime)

## 📱 Testing the App

### Test iOS Blocking
1. Launch app on real device
2. Grant FamilyControls permission
3. Select apps to block (e.g., Safari, Instagram)
4. Tap "START BLOCKING"
5. Try to open a blocked app
6. iOS will show shield screen
7. Open Halt and hold for 5 seconds to bypass

### Test Android Blocking
1. Launch app
2. Enable Accessibility Service
3. Select apps to block
4. Tap "START BLOCKING"
5. Try to open a blocked app
6. Black friction screen appears
7. Hold for 5 seconds to dismiss

## 🐛 Common Issues

### iOS: "FamilyControls not available"
- **Solution**: Must use real device, not simulator
- **Solution**: Ensure iOS 15+ on device

### Android: "Service stops after a while"
- **Solution**: Disable battery optimization for Halt
- **Solution**: Check that Foreground Service is running

### RevenueCat: "No offerings available"
- **Solution**: Verify API key is correct
- **Solution**: Ensure product ID matches exactly: `halt_pro_annual`
- **Solution**: Wait a few minutes for RevenueCat to sync

### Fonts not loading
- **Solution**: Ensure font files are in `assets/fonts/`
- **Solution**: Run `flutter clean && flutter pub get`
- **Solution**: Check [`pubspec.yaml`](pubspec.yaml:30) fonts section

## 📦 Build for Production

### iOS Production Build
```bash
# Build IPA
flutter build ipa --release

# Upload to App Store Connect
# Use Xcode → Product → Archive → Distribute App
```

### Android Production Build
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

## 🎯 Next Steps

1. **Customize branding**
   - Update app name in [`pubspec.yaml`](pubspec.yaml:1)
   - Change package name in Android/iOS configs

2. **Add analytics** (optional)
   - Firebase Analytics
   - Mixpanel
   - Amplitude

3. **Implement notifications**
   - "Life Gains" alerts
   - Daily summaries
   - Streak tracking

4. **Submit to stores**
   - Follow [`README.md`](README.md:1) for submission guidelines
   - Prepare screenshots
   - Write store descriptions

## 💰 Monetization Strategy

- **Free**: 3 blocked apps max
- **Pro ($39.99/year)**: Unlimited apps + features
- **Target**: Productivity-focused professionals
- **Marketing**: "Dark luxury" positioning

## 📞 Support

- **Documentation**: See [`README.md`](README.md:1)
- **Issues**: Check common issues above
- **Contact**: support@haltapp.com

---

**Built with Flutter 🚀 | Designed for Focus 🎯 | Priced for Value 💎**
