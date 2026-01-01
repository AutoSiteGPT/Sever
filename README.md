# Halt

A high-end minimalist productivity app that blocks distracting apps with intentional friction.

## Overview

**Halt** is a premium app blocking solution designed with "dark luxury" aesthetics. It helps users maintain focus by adding a 5-second friction screen when attempting to open blocked apps. Built with Flutter for both iOS and Android.

## Features

- ✅ **App Blocking**: Select and block distracting apps
- ✅ **5-Second Friction Screen**: Hold for 5 seconds to bypass (with haptic feedback)
- ✅ **Dark Luxury UI**: Pure black (#000000) background with white (#FFFFFF) text
- ✅ **Cross-Platform**: Single codebase for iOS and Android
- ✅ **Persistent Blocking**: Survives phone restarts
- ✅ **Pro Subscription**: $39.99/year via RevenueCat
- ✅ **iOS FamilyControls Integration**: Uses Apple's Screen Time API
- ✅ **Android Accessibility Service**: System-level app detection

## Tech Stack

- **Framework**: Flutter 3.x+
- **Language**: Dart, Swift (iOS), Kotlin (Android)
- **iOS**: FamilyControls, ManagedSettings
- **Android**: AccessibilityService, Foreground Service
- **Monetization**: RevenueCat (purchases_flutter)
- **Storage**: SharedPreferences
- **State Management**: Provider

## Project Structure

```
halt/
├── lib/
│   ├── main.dart                          # App entry point with dark theme
│   ├── models/
│   │   └── blocked_app.dart               # BlockedApp model
│   ├── services/
│   │   ├── app_blocker_service.dart       # Platform-specific blocking logic
│   │   ├── storage_service.dart           # Persistent storage
│   │   └── subscription_service.dart      # RevenueCat integration
│   └── screens/
│       ├── dashboard_screen.dart          # Main dashboard
│       ├── app_selection_screen.dart      # App picker
│       ├── friction_screen.dart           # 5-second hold screen
│       └── paywall_screen.dart            # Pro subscription
├── ios/
│   └── Runner/
│       ├── AppDelegate.swift              # iOS native bridge
│       ├── Info.plist                     # iOS permissions
│       └── PrivacyInfo.xcprivacy          # Privacy manifest
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml            # Android permissions
│       ├── kotlin/com/halt/app/
│       │   ├── MainActivity.kt            # Android native bridge
│       │   ├── AppBlockerAccessibilityService.kt
│       │   ├── BlockingForegroundService.kt
│       │   └── FrictionOverlayActivity.kt
│       └── res/
│           ├── layout/
│           │   └── activity_friction_overlay.xml
│           ├── values/
│           │   └── strings.xml
│           └── xml/
│               └── accessibility_service_config.xml
└── pubspec.yaml                           # Dependencies
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.0+
- Xcode 14+ (for iOS)
- Android Studio (for Android)
- CocoaPods (for iOS dependencies)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd halt
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Add Inter font files**
   - Download Inter font from [Google Fonts](https://fonts.google.com/specimen/Inter)
   - Place `Inter-Regular.ttf` and `Inter-SemiBold.ttf` in `assets/fonts/`

4. **Create app icon**
   - Design: White square with black circle in center
   - Place in `assets/icon/app_icon.png` (1024x1024)
   - Place foreground in `assets/icon/app_icon_foreground.png`

5. **Configure RevenueCat**
   - Sign up at [RevenueCat](https://www.revenuecat.com/)
   - Create a project and get your API key
   - Update `lib/services/subscription_service.dart`:
     ```dart
     static const String _revenueCatApiKey = 'YOUR_API_KEY_HERE';
     ```
   - Create a product with ID: `halt_pro_annual` at $39.99/year

### iOS Setup

1. **Open iOS project in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure signing**
   - Select your development team
   - Update bundle identifier

3. **Add FamilyControls capability**
   - In Xcode: Target → Signing & Capabilities
   - Click "+ Capability"
   - Add "Family Controls"

4. **Update Info.plist**
   - Already configured with `NSFamilyControlsUsageDescription`

5. **Build and run**
   ```bash
   flutter run -d ios
   ```

### Android Setup

1. **Update package name** (optional)
   - In `android/app/build.gradle`, change `applicationId`
   - Update package in all Kotlin files

2. **Build and run**
   ```bash
   flutter run -d android
   ```

3. **Grant permissions**
   - When prompted, enable Accessibility Service
   - Grant overlay permission if needed

## Design Guidelines

### Colors
- Background: `#000000` (Pure Black)
- Text: `#FFFFFF` (White)
- Secondary Text: `#888888` (Gray)
- Borders: `#333333` (Dark Gray)

### Typography
- Font: Inter
- Title Weight: 600
- Body Weight: 400
- Letter Spacing: -0.02

### Layout Rules
- No rounded corners (use `BorderRadius.zero`)
- No bottom navigation bar
- Single-page vertical scroll dashboard
- Minimal animations (only progress ring)

## How It Works

### iOS (FamilyControls)
1. User grants FamilyControls authorization
2. App uses `ManagedSettingsStore` to shield selected apps
3. When user tries to open blocked app, iOS shows shield screen
4. User must open Halt and complete 5-second hold to temporarily unblock

### Android (AccessibilityService)
1. User enables Accessibility Service
2. Service monitors `TYPE_WINDOW_STATE_CHANGED` events
3. When blocked app is detected, `FrictionOverlayActivity` launches
4. User must hold for 5 seconds to dismiss overlay
5. Foreground Service keeps monitoring active

## Apple App Store Submission

### Required Information

1. **Privacy Manifest** (✅ Included)
   - `PrivacyInfo.xcprivacy` explains data usage

2. **Purpose String** (✅ Included)
   - `NSFamilyControlsUsageDescription` in Info.plist

3. **App Review Notes**
   ```
   Halt uses the FamilyControls framework to help users reduce screen time 
   by blocking selected apps. This permission is essential for the core 
   functionality of the app. We only use Screen Time controls to enable 
   app blocking and do not collect or share any user data.
   ```

## Google Play Store Submission

### Required Information

1. **Accessibility Service Declaration**
   - Explain in store listing that accessibility is used for app detection only
   - No data collection or sharing

2. **Foreground Service**
   - Declared as `specialUse` with subtype explanation

## Monetization

- **Free Tier**: Limited to 3 blocked apps
- **Pro Tier**: $39.99/year
  - Unlimited blocked apps
  - Persistent blocking
  - Priority support

## Development Notes

### Testing iOS Blocking
- FamilyControls requires a real device (not simulator)
- Must be signed with a development team

### Testing Android Blocking
- Test on physical device for best results
- Ensure battery optimization is disabled for Halt

### Common Issues

1. **iOS: Authorization fails**
   - Ensure FamilyControls capability is added
   - Check that device supports Screen Time

2. **Android: Service stops**
   - Add to battery optimization whitelist
   - Ensure Foreground Service is running

3. **RevenueCat not working**
   - Verify API key is correct
   - Check product IDs match

## License

Proprietary - All rights reserved

## Support

For support, contact: support@haltapp.com

---

**Built with "Vibe Coding" principles for 2026** 🚀
