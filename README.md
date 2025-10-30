# CAF SDK Flutter Example

This example application demonstrates how to integrate and use the CAF SDK Flutter plugin in your Flutter applications.

## Overview

This example app showcases the main features of the CAF SDK plugin:

- Document detection and validation
- Face liveness verification
- UI customization options
- Event handling and callbacks

## Features Demonstrated

- **SDK Initialization** - How to properly initialize the CAF SDK
- **Document Detection** - Complete document capture workflow
- **Face Liveness** - Face verification process
- **Event Handling** - Real-time event processing
- **Error Handling** - Proper error management and user feedback
- **UI Customization** - Theme and styling options

## Getting Started

### Prerequisites

- Flutter SDK (>=3.3.0)
- Dart SDK (^3.9.0)
- CAF SDK native libraries
- Android Studio / Xcode for platform-specific setup

### Installation

1. Clone the repository

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure platform-specific settings (see Platform Setup below)

4. Run the app:
   ```bash
   flutter run
   ```

## Platform Setup (The app already has these settings. Be sure to apply them to your standalone app)

### Android

1. **Add Maven Repositories**: Configure the project's `build.gradle.kts` file (usually located at the root level):

```gradle
repositories {
    // Caf Repository
    maven { url = uri("https://repo.combateafraude.com/android/release") }
    
    // iProov Repository (required for Face Liveness)
    maven { url = uri("https://raw.githubusercontent.com/iProov/android/master/maven/") }
    
    // FingerPrintJS Repository
    maven { setUrl("https://maven.fpregistry.io/releases") }
    
    // JitPack
    maven { setUrl("https://jitpack.io") }
}
```

2. **Permissions**: Ensure the following permissions are added to `android/app/src/main/AndroidManifest.xml`:

   ```xml
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.android.permission.READ_EXTERNAL_STORAGE" />
   ```

3. **Minimum SDK**: Verify `android/app/build.gradle.kts` has:
   ```kotlin
    android {
        defaultConfig {
            minSdk =  26
        }
    }
   ```

### iOS

1. **Camera Permission**: Add to `ios/Runner/Info.plist`:

   ```xml
    <key>NSCameraUsageDescription</key>
    <string>Allows access to the camera to capture document images.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Allows access to stored files and images for processing, if necessary.</string>
    <key>UILaunchStoryboardName</key>
   ```

2. **Deployment Target**: Ensure `ios/Podfile` has:

   ```ruby
   platform :ios, '11.0'
   ```

3. **Development Team**: When opening the project in Xcode, you'll need to configure your Apple Developer Team ID for code signing:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the "Runner" target in the project navigator
   - Go to the "Signing & Capabilities" tab
   - Select your team from the "Team" dropdown
   - Your Team ID can be found in your [Apple Developer Account](https://developer.apple.com/account) under "Membership Details"

## Usage Examples

- [Flutter Docs](https://docs.caf.io/caf-sdk/flutter/getting-started-with-the-sdk)

## Testing

To test the example app:

1. **Device Testing**: Run on physical devices for best camera performance
2. **Different Scenarios**: Test various document types and lighting conditions
3. **Error Cases**: Test with invalid configurations or network issues
4. **UI Customization**: Verify different theme and styling options

## Troubleshooting

### Common Issues

1. **Camera Permission Denied**

   - Ensure permissions are properly configured
   - Check device settings for camera access

2. **SDK Initialization Failed**

   - Verify configuration parameters
   - Check network connectivity
   - Ensure native libraries are properly integrated

3. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Check platform-specific setup requirements
   - Verify Flutter and Dart SDK versions

## Support

For additional help:

- Review the [plugin documentation](https://pub.dev/packages/caf_sdk)
- Review the [SDK documentation](https://docs.caf.io/caf-sdk/flutter/getting-started-with-the-sdk)
- Check the API reference for detailed configuration options
- Contact the development team for technical support

## License

This example app is provided as-is for demonstration purposes. Please refer to the main plugin license for usage terms.
