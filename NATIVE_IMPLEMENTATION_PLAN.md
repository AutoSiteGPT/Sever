# Native Implementation Plan

## Current State Analysis

### ✅ Already Implemented
- Flutter UI (complete)
- MethodChannel defined: `com.halt.app/blocker`
- Basic Android AccessibilityService
- Basic iOS FamilyControls integration
- Foreground Service structure
- Friction overlay activity

### ❌ Missing Critical Functionality

#### Android
1. **Persistence** - Blocked apps not persisted in native layer
2. **UsageStats Permission** - Not requested
3. **Battery Optimization** - Not handled
4. **Reboot Persistence** - Service doesn't restart
5. **Subscription Check** - Not enforced before blocking

#### iOS
6. **FamilyActivityPicker** - Not implemented (currently shields ALL apps)
7. **DeviceActivity Extension** - Missing
8. **App Groups** - Not configured
9. **Proper Token Management** - Bundle IDs not converted to tokens
10. **Subscription Check** - Not enforced

## Implementation Strategy

### Phase 1: Android Enhancements (ADDITIVE ONLY)
- Add `BlockedAppsStorage.kt` for native persistence
- Add `PermissionManager.kt` for UsageStats + Battery
- Add `BootReceiver.kt` for restart persistence
- Enhance `BlockingForegroundService.kt` with subscription checks
- Update `AndroidManifest.xml` with new permissions

### Phase 2: iOS Enhancements (ADDITIVE ONLY)
- Add `BlockedAppsManager.swift` for token management
- Add `DeviceActivityMonitor` extension
- Add `AppGroupManager.swift` for shared data
- Update `AppDelegate.swift` to use proper FamilyActivityPicker
- Add entitlements configuration

### Phase 3: Documentation
- Setup instructions for new permissions
- App Store submission notes
- Play Store policy compliance

## Files to Add (NO MODIFICATIONS TO EXISTING DART)

### Android
- `android/app/src/main/kotlin/com/halt/app/BlockedAppsStorage.kt`
- `android/app/src/main/kotlin/com/halt/app/PermissionManager.kt`
- `android/app/src/main/kotlin/com/halt/app/BootReceiver.kt`
- Update `android/app/src/main/AndroidManifest.xml` (permissions only)

### iOS
- `ios/Runner/BlockedAppsManager.swift`
- `ios/Runner/AppGroupManager.swift`
- `ios/HaltDeviceActivityMonitor/` (new extension)
- `ios/Runner.entitlements`
- `ios/HaltDeviceActivityMonitor.entitlements`

### Documentation
- `NATIVE_SETUP_GUIDE.md`
- `STORE_SUBMISSION_NOTES.md`

## Method Channel Mapping (UNCHANGED)

| Dart Method | Android Handler | iOS Handler |
|-------------|----------------|-------------|
| `checkAccessibilityPermission` | ✅ Implemented | N/A |
| `requestAccessibilityPermission` | ✅ Implemented | N/A |
| `checkFamilyControlsAuthorization` | N/A | ✅ Implemented |
| `requestFamilyControlsAuthorization` | N/A | ✅ Implemented |
| `startBlockingService` | ✅ Needs enhancement | N/A |
| `stopBlockingService` | ✅ Implemented | N/A |
| `shieldApplications` | N/A | ⚠️ Needs proper implementation |
| `unshieldApplications` | N/A | ✅ Implemented |
| `getInstalledApps` | ✅ Implemented | N/A |

## Critical Rules
1. ❌ DO NOT modify any Dart files
2. ❌ DO NOT change existing method signatures
3. ❌ DO NOT rename classes or files
4. ✅ ONLY add new files
5. ✅ ONLY enhance existing native implementations
6. ✅ Maintain backward compatibility

## Success Criteria
- [ ] App blocks work on real Android devices
- [ ] App blocks work on real iOS devices
- [ ] Blocking survives app restart
- [ ] Blocking survives device reboot (Android)
- [ ] Subscription is enforced
- [ ] All permissions properly requested
- [ ] No crashes if permissions denied
- [ ] Passes Play Store review
- [ ] Passes App Store review
