# Info.plist Configuration

## Required Privacy Descriptions

Add these keys to your Info.plist file in Xcode:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Configuration -->
    <key>CFBundleDisplayName</key>
    <string>Resource</string>

    <key>CFBundleName</key>
    <string>ResourceInventory</string>

    <key>CFBundleIdentifier</key>
    <string>com.resource.inventory</string>

    <!-- Minimum iOS Version -->
    <key>MinimumOSVersion</key>
    <string>17.0</string>

    <!-- Privacy - Face ID Usage -->
    <key>NSFaceIDUsageDescription</key>
    <string>نحتاج إلى Face ID لحماية بياناتك وضمان أمان معلومات منتجاتك الرقمية</string>

    <!-- Supported Interface Orientations -->
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
    </array>

    <!-- Required Device Capabilities -->
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>

    <!-- Supports Dark Mode -->
    <key>UIUserInterfaceStyle</key>
    <string>Automatic</string>

    <!-- Launch Screen -->
    <key>UILaunchScreen</key>
    <dict>
        <key>UIColorName</key>
        <string>AccentColor</string>
        <key>UIImageName</key>
        <string>LaunchIcon</string>
    </dict>
</dict>
</plist>
```

## App Capabilities Required

In Xcode, enable these capabilities in your target's "Signing & Capabilities" tab:

1. **App Groups** (optional, for future extensions)
2. **Push Notifications** (for subscription expiry alerts)

## Entitlements

No special entitlements required beyond standard app capabilities.

## Privacy Manifest

For App Store submission, you may need to create a PrivacyInfo.xcprivacy file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>

    <key>NSPrivacyTrackingDomains</key>
    <array/>

    <key>NSPrivacyCollectedDataTypes</key>
    <array/>

    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

## Notes

- All data is stored locally using SwiftData
- No network requests are made
- No third-party analytics or tracking
- Biometric data never leaves the device (handled by iOS)
