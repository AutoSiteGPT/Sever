# Native Setup Guide

Complete guide for setting up native Android and iOS functionality for the Sever app.

## 🤖 Android Setup

### Prerequisites
- Android Studio installed
- Physical Android device (API 24+)
- USB debugging enabled

### Step 1: Build the App
```bash
flutter build apk --debug
# or
flutter run -d <android-device-id>
```

### Step 2: Grant Accessibility Permission

1. Open the Sever app
2. Tap "START BLOCKING"
3. App will open Accessibility Settings
4. Find "Sever" in the list
5. Toggle ON
6. Confirm the warning dialog

**Why needed:** Accessibility Service detects when blocked apps are launched.

### Step 3: Grant UsageStats Permission

The app will automatically request this when you start blocking.

1. Settings will open automatically
2. Find "Sever" in the list
3. Toggle "Permit usage access" ON

**Why needed:** Required for detecting foreground app changes on Android 10+.

### Step 4: Disable Battery Optimization

The app will request this automatically.

1. Tap "Allow" when prompted
2. Or manually: Settings → Battery → Battery Optimization
3. Find "Sever"
4. Select "Don't optimize"

**Why needed:** Prevents Android from killing the blocking service.

### Step 5: Test Blocking

1. In Sever app, tap "SELECT APPS"
2. Choose apps to block (e.g., Instagram, Twitter)
3. Tap "SAVE"
4. Tap "START BLOCKING"
5. Try to open a blocked app
6. Black friction screen should appear
7. Hold for 5 seconds to bypass

### Step 6: Test Reboot Persistence

1. With blocking active, restart your device
2. After reboot, try to open a blocked app
3. Friction screen should still appear
4. Blocking service auto-restarts

### Troubleshooting Android

**Problem:** Friction screen doesn't appear
- **Solution:** Check Accessibility Service is enabled
- **Solution:** Check UsageStats permission granted
- **Solution:** Restart the app

**Problem:** Service stops after a while
- **Solution:** Disable battery optimization
- **Solution:** Check if manufacturer has aggressive battery management
- **Solution:** Add Sever to "Protected apps" (Huawei, Xiaomi, etc.)

**Problem:** Blocking doesn't survive reboot
- **Solution:** Check RECEIVE_BOOT_COMPLETED permission
- **Solution:** Ensure app is not in "Restricted" battery mode

## 🍎 iOS Setup

### Prerequisites
- Xcode 14+ installed
- Physical iOS device (iOS 15+)
- Apple Developer account
- Device registered in developer portal

### Step 1: Configure Xcode Project

```bash
cd ios
open Runner.xcworkspace
```

### Step 2: Add FamilyControls Capability

1. In Xcode, select "Runner" target
2. Go to "Signing & Capabilities" tab
3. Click "+ Capability"
4. Search for "Family Controls"
5. Add it

### Step 3: Configure Signing

1. Select your development team
2. Ensure bundle identifier is unique
3. Connect your iOS device
4. Select it as the build target

### Step 4: Build and Run

```bash
# From project root
flutter run -d <ios-device-id>
```

### Step 5: Grant FamilyControls Authorization

1. Open Sever app
2. Tap "START BLOCKING"
3. iOS will show FamilyControls permission dialog
4. Tap "Allow"
5. Authenticate with Face ID/Touch ID/Passcode

**Why needed:** Required by Apple to use Screen Time controls.

### Step 6: Test Blocking

⚠️ **Current Limitation:** iOS implementation currently blocks ALL apps, not selective.

1. In Sever app, enable blocking
2. Try to open any app
3. iOS will show a shield screen
4. Open Sever app
5. Disable blocking to access apps again

### iOS Known Limitations

**Selective App Blocking:**
- iOS FamilyControls requires `FamilyActivityPicker` UI component
- User must manually select apps through Apple's picker
- Cannot programmatically block by bundle ID
- Current implementation blocks ALL apps as a workaround

**To implement selective blocking:**
- Requires adding FamilyActivityPicker to Flutter UI
- Requires modifying Dart code
- Planned for future update

### Troubleshooting iOS

**Problem:** FamilyControls authorization fails
- **Solution:** Ensure device is iOS 15+
- **Solution:** Check FamilyControls capability is added
- **Solution:** Verify app is signed with valid provisioning profile

**Problem:** Shield doesn't appear
- **Solution:** Check authorization was granted
- **Solution:** Restart the app
- **Solution:** Check device restrictions (Screen Time must be available)

**Problem:** Can't build in Xcode
- **Solution:** Run `pod install` in ios/ directory
- **Solution:** Clean build folder (Cmd+Shift+K)
- **Solution:** Delete DerivedData

## 🔐 Permissions Summary

### Android Permissions
| Permission | Purpose | When Requested |
|------------|---------|----------------|
| Accessibility Service | Detect app launches | When starting blocking |
| UsageStats | Foreground app detection | When starting blocking |
| Battery Optimization | Keep service alive | When starting blocking |
| Boot Completed | Restart after reboot | Automatically |
| System Alert Window | Show friction overlay | Automatically |

### iOS Permissions
| Permission | Purpose | When Requested |
|------------|---------|----------------|
| FamilyControls | Screen Time API access | When starting blocking |

## 📱 Testing Checklist

### Android
- [ ] Accessibility permission granted
- [ ] UsageStats permission granted
- [ ] Battery optimization disabled
- [ ] Apps selected for blocking
- [ ] Blocking service starts
- [ ] Friction screen appears
- [ ] 5-second hold works
- [ ] Blocking survives app restart
- [ ] Blocking survives device reboot
- [ ] Notification shows when blocking active

### iOS
- [ ] FamilyControls authorization granted
- [ ] Blocking can be enabled
- [ ] Shield appears when blocking active
- [ ] Can disable blocking
- [ ] Authorization persists across app restarts

## 🚀 Production Deployment

### Android
1. Build release APK/AAB
2. Sign with release keystore
3. Test on multiple devices
4. Verify all permissions work
5. Test reboot persistence
6. Submit to Play Store

### iOS
1. Archive in Xcode
2. Upload to App Store Connect
3. Test with TestFlight
4. Verify FamilyControls works
5. Submit for review with notes about current limitations

## 📞 Support

If you encounter issues:
1. Check this guide first
2. Review NATIVE_IMPLEMENTATION_COMPLETE.md
3. Check device compatibility
4. Verify all permissions granted
5. Try on a different device

## 🔄 Future Enhancements

### Planned
- iOS selective app blocking (requires UI changes)
- Usage statistics and analytics
- Scheduled blocking
- Focus modes
- Whitelist functionality

### Not Possible
- iOS programmatic app selection (Apple limitation)
- Android blocking without Accessibility (OS limitation)
