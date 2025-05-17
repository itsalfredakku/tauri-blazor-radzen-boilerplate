# Mobile Development Setup

This guide explains how to set up and build the Tauri + Blazor + Radzen boilerplate application for mobile platforms (Android and iOS).

## Prerequisites

### Common Requirements

- [Rust](https://www.rust-lang.org/tools/install) (stable toolchain)
- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Tauri CLI](https://tauri.app/v2/guides/getting-started/prerequisites) with mobile features
  ```bash
  cargo install tauri-cli --features android,ios
  ```

## Android Setup

### Requirements

1. **Install Android Studio**:
   - Download and install [Android Studio](https://developer.android.com/studio)
   - During installation, ensure you select:
     - Android SDK
     - Android SDK Platform
     - Android Virtual Device (for emulator)

2. **Install Android SDK components**:
   - Open Android Studio → Settings/Preferences → Appearance & Behavior → System Settings → Android SDK
   - In the SDK Platforms tab, install:
     - Latest Android SDK (e.g., Android 14/API Level 34)
     - Android 13 (API Level 33) for broader compatibility
   - In the SDK Tools tab, install:
     - Android SDK Build-Tools
     - NDK (Side by side) - at least version 25.2.9519653
     - Android SDK Command-line Tools
     - Android SDK Platform-Tools

3. **Set environment variables**:
   Add these to your shell profile (`.bashrc`, `.zshrc`, etc.):

   ```bash
   # Android SDK path (adjust as needed)
   export ANDROID_HOME=$HOME/Android/Sdk    # Linux
   export ANDROID_HOME=$HOME/Library/Android/sdk    # macOS
   export ANDROID_HOME=%LOCALAPPDATA%\\Android\\Sdk    # Windows

   # Android NDK path - check your actual NDK version
   export NDK_HOME=$ANDROID_HOME/ndk/25.2.9519653
   
   # Add to PATH
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
   ```

4. **Install Rust targets for Android**:
   ```bash
   rustup target add aarch64-linux-android x86_64-linux-android
   ```

5. **Install additional tools**:
   ```bash
   cargo install cargo-ndk
   ```

### Initializing Android Support

1. From your project directory, initialize Android support:
   ```bash
   cargo tauri android init
   ```

2. This creates the necessary Android project files in `src-tauri/gen/android/`

3. Modify the generated Android files as needed:
   - Update app metadata in `src-tauri/gen/android/app/src/main/AndroidManifest.xml`
   - Add Android-specific icons in `src-tauri/gen/android/app/src/main/res/`

### Building for Android

#### Development Build

```bash
# Run on connected device or emulator
cargo tauri android dev
```

#### Production Build

```bash
# Create APK/AAB for release
cargo tauri android build
```

The built APK will be located at:
- Debug: `src-tauri/gen/android/app/build/outputs/apk/debug/app-debug.apk`
- Release: `src-tauri/gen/android/app/build/outputs/apk/release/app-release.apk`

## iOS Setup (macOS only)

### Requirements

1. **Install Xcode**:
   - Install [Xcode](https://apps.apple.com/us/app/xcode/id497799835) from the Mac App Store
   - Install Xcode Command Line Tools:
     ```bash
     xcode-select --install
     ```

2. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

3. **Install Rust targets for iOS**:
   ```bash
   rustup target add aarch64-apple-ios x86_64-apple-ios
   ```

### Initializing iOS Support

1. From your project directory, initialize iOS support:
   ```bash
   cargo tauri ios init
   ```

2. This creates the necessary iOS project files in `src-tauri/gen/ios/`

3. Update iOS-specific configurations:
   - Update app metadata in `src-tauri/gen/ios/[AppName]/Info.plist`
   - Add iOS-specific icons in `src-tauri/gen/ios/[AppName]/Assets.xcassets/`

### Building for iOS

#### Development Build

```bash
# Open in Xcode or run in simulator
cargo tauri ios dev
```

#### Production Build

```bash
# Build for release
cargo tauri ios build
```

For the final app submission, you'll need to:
1. Open the generated Xcode project: `src-tauri/gen/ios/[AppName].xcworkspace`
2. Configure certificates and provisioning profiles
3. Build with Xcode for App Store submission

## Troubleshooting

### Android Issues

1. **SDK/NDK Not Found**:
   - Verify environment variables are set correctly
   - Run `adb devices` to check if ADB is in your PATH

2. **Build Errors**:
   - Update Android Studio and all SDK components
   - Check that your NDK version matches the one in environment variables

3. **Emulator Issues**:
   - Create an AVD with Android Studio's AVD Manager
   - Consider using a physical device for better performance

### iOS Issues

1. **Build Failed**:
   - Make sure you have the latest Xcode and Xcode Command Line Tools
   - Run `pod repo update` to update CocoaPods repository

2. **Simulator Not Working**:
   - Reset the iOS simulator from the "Device" menu
   - Try different simulator versions

3. **Certificate Issues**:
   - Use Xcode's Automatic Signing option for development
   - For distribution, create appropriate certificates in Apple Developer Portal

## Performance Tips

- Use release builds when testing on physical devices for accurate performance assessment
- For Android, use the latest NDK for best performance
- For iOS, test on both simulator and physical devices as performance can differ significantly
