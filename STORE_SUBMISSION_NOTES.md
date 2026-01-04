# Store Submission Notes

Critical information for submitting Sever to Google Play Store and Apple App Store.

## 🤖 Google Play Store Submission

### App Category
**Productivity**

### Content Rating
- Target Audience: Everyone
- No ads, no in-app purchases (except subscription)
- No user-generated content
- No social features

### Privacy Policy Requirements

**Data Collection:**
- App does NOT collect or transmit user data
- Blocked apps list stored locally only
- No analytics or tracking
- No third-party SDKs (except RevenueCat for payments)

**Privacy Policy Must State:**
```
Sever does not collect, store, or transmit any personal data.
All app blocking preferences are stored locally on your device.
We use RevenueCat only for processing subscription payments.
```

### Permissions Justification

**1. Accessibility Service**
```
Purpose: Detect when blocked apps are launched to display friction screen
Data Access: App package names only
Data Usage: Used only to compare against user's blocked apps list
Data Sharing: No data is shared or transmitted
Retention: Data is not retained; only used in real-time
```

**2. UsageStats Permission**
```
Purpose: Detect foreground app changes on Android 10+
Data Access: App usage events
Data Usage: Used only to identify currently running app
Data Sharing: No data is shared or transmitted
Retention: Data is not stored or retained
```

**3. Battery Optimization**
```
Purpose: Keep blocking service running in background
Justification: Core functionality requires persistent service
User Benefit: Ensures app blocking works reliably
```

**4. Boot Completed**
```
Purpose: Restart blocking service after device reboot
Justification: Maintains user's blocking preferences
User Benefit: Blocking persists across reboots
```

### Accessibility Service Declaration

**Required Form Fields:**

**Service Name:** Sever App Blocker

**Service Description:**
```
Sever uses Accessibility Service to detect when you attempt to open blocked apps.
When a blocked app is detected, Sever displays a friction screen requiring you to
hold for 5 seconds before proceeding. This intentional friction helps reduce
impulsive app usage and improve focus.

The service only monitors app launch events and does not access any content,
personal data, or user interactions within apps.
```

**Data Handling:**
- Does NOT collect user data
- Does NOT transmit data off device
- Does NOT share data with third parties

**Use Case:** Productivity / Focus / Digital Wellbeing

### Foreground Service Declaration

**Service Type:** specialUse

**Justification:**
```
Sever uses a foreground service to maintain app blocking functionality while
the app is in the background. This is essential for the core purpose of the
app - preventing access to distracting apps. The service displays a persistent
notification and can be stopped at any time by the user.
```

### Screenshots Required
1. Main dashboard (blocking inactive)
2. App selection screen
3. Blocking active with notification
4. Friction screen (5-second hold)
5. Permissions explanation screen

### Feature Graphic
- 1024 x 500 px
- Show app icon + "Sever" text
- Dark theme (#000000 background)
- Minimalist design

### App Description Template

**Short Description (80 chars):**
```
Block distracting apps with intentional friction. Focus on what matters.
```

**Full Description:**
```
SEVER - Intentional Friction for Focus

Sever helps you break phone addiction by adding a 5-second friction screen
before opening distracting apps. This intentional pause gives you time to
reconsider and make conscious choices about your screen time.

KEY FEATURES:
• Block any apps you choose
• 5-second hold to bypass (intentional friction)
• Blocking persists across restarts
• Dark, minimalist interface
• No data collection or tracking

HOW IT WORKS:
1. Select apps you want to block
2. Enable blocking
3. When you try to open a blocked app, a friction screen appears
4. Hold for 5 seconds to proceed
5. This pause helps you make conscious choices

PERMISSIONS:
• Accessibility: Detect when blocked apps are launched
• UsageStats: Monitor foreground app (Android 10+)
• Battery: Keep blocking service running
• Boot: Restart blocking after reboot

All data stays on your device. No tracking. No ads.

PRO VERSION:
• Unlimited blocked apps
• Advanced scheduling
• Focus modes
• Priority support

Built for people who want to use their phone intentionally, not impulsively.
```

### Review Notes for Google

```
IMPORTANT NOTES FOR REVIEWERS:

1. ACCESSIBILITY SERVICE USAGE:
   - Used ONLY to detect app launches
   - Does NOT access app content or user data
   - Does NOT perform automated actions
   - Only displays our own friction screen

2. TESTING THE APP:
   - Grant Accessibility permission when prompted
   - Grant UsageStats permission when prompted
   - Disable battery optimization when prompted
   - Select test apps (e.g., Chrome, Gmail)
   - Enable blocking
   - Try to open a blocked app
   - Friction screen will appear
   - Hold the circle for 5 seconds to bypass

3. FOREGROUND SERVICE:
   - Required for core functionality
   - User can stop it anytime
   - Shows persistent notification
   - Clearly labeled "Sever is Active"

4. NO DATA COLLECTION:
   - All data stored locally
   - No analytics
   - No tracking
   - No third-party SDKs (except payment processing)

Test Account: Not required (no login)
```

## 🍎 Apple App Store Submission

### App Category
**Productivity**

### Age Rating
- 4+ (No objectionable content)

### Privacy Nutrition Label

**Data Not Collected:**
- No data collection
- No tracking
- No third-party analytics

**Data Used for Functionality:**
- Screen Time data (via FamilyControls)
- Stays on device
- Not linked to user identity

### FamilyControls Usage Justification

**Purpose String (Already in Info.plist):**
```
Sever uses Screen Time controls to help you reduce distractions by blocking
selected apps. This permission is required to enable app blocking functionality
and help you maintain focus on what matters most.
```

### App Review Notes

```
IMPORTANT NOTES FOR REVIEWERS:

1. FAMILYCONTROLS FRAMEWORK:
   - Used for legitimate Screen Time / Digital Wellbeing purpose
   - Helps users reduce phone usage
   - User has full control
   - Can disable anytime

2. CURRENT LIMITATION:
   - iOS implementation currently blocks ALL apps when enabled
   - This is due to FamilyControls API limitations
   - Selective blocking requires FamilyActivityPicker UI
   - Planned for future update

3. TESTING THE APP:
   - Grant FamilyControls permission when prompted
   - Authenticate with Face ID/Touch ID
   - Enable blocking in the app
   - Try to open any app
   - iOS will show shield screen
   - Open Sever app to disable blocking

4. WHY ALL APPS:
   - FamilyControls requires FamilyActivityPicker for selective blocking
   - This is a platform UI component
   - Current version uses ManagedSettingsStore directly
   - Future version will integrate FamilyActivityPicker

5. USER BENEFIT:
   - Helps reduce phone addiction
   - Promotes mindful usage
   - User maintains full control
   - No data collection

Test Account: Not required (no login)
Device: Must test on physical device (iOS 15+)
```

### Screenshots Required (iPhone)
1. Main dashboard
2. FamilyControls permission dialog
3. Blocking enabled
4. Shield screen (iOS native)
5. Settings/preferences

### Screenshots Required (iPad)
- Same as iPhone but iPad-sized

### App Preview Video (Optional but Recommended)
- 15-30 seconds
- Show: Open app → Enable blocking → Try to open app → Shield appears
- Emphasize: "Take back control of your time"

### Privacy Policy URL
Must host privacy policy at a public URL:

```
https://yourdomain.com/privacy

Content:
SEVER PRIVACY POLICY

Last Updated: [Date]

Sever does not collect, store, or transmit any personal information.

DATA COLLECTION:
- We do not collect any user data
- We do not use analytics or tracking
- We do not share data with third parties

LOCAL STORAGE:
- Your app blocking preferences are stored locally on your device
- This data never leaves your device

FAMILYCONTROLS:
- We use Apple's FamilyControls framework for app blocking
- This data is managed by iOS and stays on your device
- We do not access or transmit this data

PAYMENTS:
- Subscription payments are processed by RevenueCat
- RevenueCat's privacy policy applies to payment data
- We do not store payment information

CONTACT:
support@severapp.com

This privacy policy may be updated. Check this page for changes.
```

### Support URL
```
https://yourdomain.com/support
```

### Marketing URL (Optional)
```
https://yourdomain.com
```

## 🎯 Common Rejection Reasons & Solutions

### Google Play

**Rejection: "Accessibility Service Misuse"**
- **Solution:** Emphasize it's for Digital Wellbeing
- **Solution:** Show it only detects launches, doesn't interact
- **Solution:** Provide detailed explanation in review notes

**Rejection: "Foreground Service Unnecessary"**
- **Solution:** Explain it's core functionality
- **Solution:** Show user can stop it anytime
- **Solution:** Reference Digital Wellbeing category

**Rejection: "Permissions Not Justified"**
- **Solution:** Add in-app explanation screens
- **Solution:** Show permission dialogs with context
- **Solution:** Update store listing with clear explanations

### Apple App Store

**Rejection: "FamilyControls Misuse"**
- **Solution:** Emphasize parental control / digital wellbeing use case
- **Solution:** Show user maintains control
- **Solution:** Explain it helps reduce screen time

**Rejection: "Blocks System Functions"**
- **Solution:** Explain user can disable anytime
- **Solution:** Show it's opt-in
- **Solution:** Clarify it's for user's own benefit

**Rejection: "Incomplete Functionality"**
- **Solution:** Explain iOS API limitations
- **Solution:** Note selective blocking planned for future
- **Solution:** Current version is functional (blocks all apps)

## ✅ Pre-Submission Checklist

### Both Stores
- [ ] Privacy policy hosted and accessible
- [ ] Support email configured
- [ ] All screenshots prepared
- [ ] App description finalized
- [ ] Review notes prepared
- [ ] Test account created (if needed)
- [ ] App tested on multiple devices
- [ ] All permissions working
- [ ] No crashes or bugs

### Google Play Specific
- [ ] Accessibility Service declaration complete
- [ ] Foreground Service justification provided
- [ ] Content rating completed
- [ ] Target API level met
- [ ] 64-bit support enabled

### App Store Specific
- [ ] Privacy Nutrition Label completed
- [ ] FamilyControls justification clear
- [ ] Tested on physical device
- [ ] Screenshots include iOS native elements
- [ ] App Preview video (optional)

## 📞 Appeal Process

If rejected, respond professionally:

```
Thank you for reviewing our app. We understand your concerns about [issue].

Sever is designed as a Digital Wellbeing tool to help users reduce phone
addiction through intentional friction. Here's how we address your concerns:

[Specific response to rejection reason]

We've also:
- Added clearer in-app explanations
- Updated our privacy policy
- Improved permission request flow
- Added more context in review notes

We believe Sever provides genuine value to users struggling with phone
addiction and would appreciate reconsideration.

Thank you for your time.
```

## 🚀 Post-Approval

### Monitor
- User reviews
- Crash reports
- Permission grant rates
- Uninstall rates

### Respond to Reviews
- Thank positive reviews
- Address concerns in negative reviews
- Fix reported bugs quickly
- Update regularly

### Future Updates
- Add selective iOS blocking (requires UI changes)
- Improve permission flow
- Add usage statistics
- Implement scheduling features

---

**Remember:** Both stores prioritize user safety and privacy. Be transparent,
provide clear explanations, and demonstrate genuine user benefit.
