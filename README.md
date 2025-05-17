# Tauri + Blazor + Radzen - Boilerplate

<p align="center" style="margin-bottom: 30px;">
  <img src="src/wwwroot/images/tauri.svg" alt="Tauri" width="150" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="src/wwwroot/images/blazor.png" alt="Blazor" width="150" /> 
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="src/wwwroot/images/radzen.png" alt="Radzen" width="150" />
</p>

A modern, lightweight application boilerplate combining the power of [Tauri](https://tauri.app/), [Blazor WebAssembly](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor), and [Radzen](https://blazor.radzen.com/) for desktop, web, and mobile platforms.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Development Setup](#development-setup)
  - [VS Code Integration](#vs-code-integration)
- [Building](#building)
  - [Development Builds](#development-builds)
  - [Production Builds](#production-builds)
  - [Platform-Specific Builds](#platform-specific-builds)
    - [macOS Universal Binary](#macos-universal-binary)
    - [Android](#android)
    - [iOS](#ios)
- [Advanced Features](#advanced-features)
  - [Theme Management](#theme-management)
  - [Tauri API Examples](#tauri-api-examples)
  - [Error Handling](#error-handling)
  - [Loading Indicators](#loading-indicators)
  - [Responsive Design](#responsive-design)
- [Performance Optimizations](#performance-optimizations)
- [CI/CD](#cicd)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Features

- **Lightweight Desktop Framework**: Tauri offers much smaller bundle sizes compared to Electron
- **Blazor WebAssembly**: Build interactive web UIs with C# instead of JavaScript
- **No Node.js Required**: Pure .NET and Rust stack without JavaScript toolchain dependencies
- **Secure by Default**: Harnesses Tauri's security-focused architecture
- **Cross-Platform**: Works on Windows, macOS, Linux, Android, and iOS
- **Radzen Components**: Beautiful UI components from Radzen
- **Material 3 Design**: Modern design system with light/dark mode support
- **Built with .NET 9.0**: Leverages the latest .NET features

## Project Structure

The project is organized as follows:

```
/
├── .cargo/                # Cargo configuration
├── .github/               # GitHub workflows for CI/CD
│   └── workflows/         # CI, release, and changelog automation
├── .vscode/               # VS Code configuration
│   ├── launch.json        # Debug configurations
│   ├── tasks.json         # Build tasks
│   ├── settings.json      # Editor settings
│   └── extensions.json    # Recommended extensions
├── docs/                  # Documentation files
├── scripts/               # Build and utility scripts
│   ├── build-macos-universal.sh    # macOS universal binary build script
│   ├── fast-build.sh               # Optimized build script
│   ├── optimize-rust.sh            # Rust optimization script
│   └── run-project.sh              # Development runner
├── src/                   # Blazor WebAssembly application
│   ├── Components/        # Reusable Blazor components
│   ├── Layout/            # Application layout components
│   ├── Pages/             # Application pages
│   ├── Properties/        # .NET project properties
│   ├── Services/          # Application services
│   ├── wwwroot/           # Static web assets
│   │   ├── css/           # Stylesheets including Material 3
│   │   ├── fonts/         # Application fonts
│   │   └── images/        # Images and icons
│   ├── App.razor          # Root Blazor component
│   ├── Program.cs         # Application entry point
│   └── TauriBlazorBoilerplate.csproj  # .NET project file
└── src-tauri/             # Tauri native application
    ├── capabilities/      # Tauri capabilities configuration
    ├── icons/             # Application icons
    ├── src/               # Rust source code
    │   ├── lib.rs         # Core functionality
    │   └── main.rs        # Native application entry point
    ├── build.rs           # Tauri build script
    ├── Cargo.toml         # Rust dependencies
    ├── rust-toolchain.toml # Rust toolchain specification
    └── tauri.conf.json    # Tauri configuration
```

## Getting Started

### Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Rust](https://www.rust-lang.org/tools/install)
- [Tauri Prerequisites](https://tauri.app/v1/guides/getting-started/prerequisites) for your platform
- For mobile development:
  - [Android Studio](https://developer.android.com/studio) (for Android)
  - [Xcode](https://developer.apple.com/xcode/) (for iOS, macOS only)

### Development Setup

1. Clone the repository:

```bash
git clone https://github.com/devstroop/tauri-blazor-boilerplate.git
cd tauri-blazor-boilerplate
```

2. Install Tauri CLI:

```bash
cargo install tauri-cli
```

3. Install Rust targets (for cross-compilation or platform-specific builds):

```bash
# For macOS universal builds
rustup target add x86_64-apple-darwin aarch64-apple-darwin

# For Android (arm64 and x86_64)
rustup target add aarch64-linux-android x86_64-linux-android

# For iOS (arm64)
rustup target add aarch64-apple-ios

# For standard platforms if needed
rustup target add x86_64-unknown-linux-gnu
rustup target add x86_64-pc-windows-msvc
```

4. Make scripts executable:

```bash
chmod +x scripts/*.sh
```

5. Run the development server:

```bash
cargo tauri dev
```

### VS Code Integration

This project includes VS Code configurations for optimal development:

- **Tasks**: Press `Ctrl+Shift+B` (Windows/Linux) or `Cmd+Shift+B` (macOS) to access build tasks
  - `fast-build`: Quick development build
  - `fast-build-release`: Optimized release build
  - `build-macos-universal`: Universal macOS binary build
  - `fast-build-universal`: Quick universal macOS build

- **Debugging**: Press `F5` to start debugging or use the Run panel
  - `Tauri: Boilerplate Debug`: Debug full application
  - `Blazor: Boilerplate Debug`: Debug only Blazor WebAssembly
  - `Attach to Blazor WebAssembly`: Attach to running WebAssembly

## Building

### Development Builds

For quick iteration during development:

```bash
# Start the development server with hot reloading
cargo tauri dev

# Fast build with development optimizations
./scripts/fast-build.sh
```

### Production Builds

Build production-ready applications:

```bash
# Standard production build
cargo tauri build

# Optimized release build with our script
./scripts/fast-build.sh --release
```

### Platform-Specific Builds

#### macOS Universal Binary

Create a universal binary compatible with both Intel and Apple Silicon Macs:

```bash
# Using the dedicated script
./scripts/build-macos-universal.sh

# Or using the fast-build script with universal flag
./scripts/fast-build.sh --universal --release

# Or directly with cargo
cargo tauri build --target universal-apple-darwin
```

For more information, see [MACOS_UNIVERSAL_BUILDS.md](docs/MACOS_UNIVERSAL_BUILDS.md).

#### Android

To build for Android:

1. Install Android prerequisites:
   ```bash
   # Install Android SDK and NDK via Android Studio

   # Set environment variables (add to your shell profile)
   export ANDROID_HOME=/path/to/android/sdk
   export NDK_HOME=$ANDROID_HOME/ndk/[version]
   ```

2. Install Tauri Android CLI tools:
   ```bash
   cargo install tauri-cli --features android
   cargo install cargo-ndk
   ```

3. Add Android-specific configuration to `tauri.conf.json`:
   ```bash
   # Execute from project root
   cargo tauri android init
   ```

4. Build for Android:
   ```bash
   # Development build
   cargo tauri android dev

   # Production build
   cargo tauri android build
   ```

The APK will be generated in `src-tauri/gen/android/app/build/outputs/apk/`.

#### iOS

To build for iOS (requires macOS):

1. Install iOS prerequisites:
   ```bash
   # Install Xcode Command Line Tools
   xcode-select --install

   # Install Tauri iOS CLI tools
   cargo install tauri-cli --features ios
   ```

2. Add iOS-specific configuration to `tauri.conf.json`:
   ```bash
   # Execute from project root
   cargo tauri ios init
   ```

3. Build for iOS:
   ```bash
   # Development build
   cargo tauri ios dev

   # Production build
   cargo tauri ios build
   ```

Open the generated Xcode project in `src-tauri/gen/ios/[AppName]` and run on a simulator or device.

## Advanced Features

### Theme Management
- Light/Dark mode toggle with Material 3 design
- Persistent theme settings

### Tauri API Examples
- Native dialogs and file system access
- Window management and system information
- Cross-platform APIs

### Error Handling
- Global error handler with notifications
- Structured logging

### Loading Indicators
- Application loading spinner
- Operation progress indicators

### Responsive Design
- Mobile-first approach
- Adaptive layouts

## Performance Optimizations

### Rust Compilation Optimizations
- Custom `.cargo/config.toml` with optimized settings
- Specific toolchain requirements in `rust-toolchain.toml`
- CI/CD optimizations with efficient caching
- Release build tuning for smaller, faster binaries

### Development Workflow Optimizations
- Incremental compilation for faster dev cycles
- Efficient dependency caching
- Parallel compilation enabled by default

## CI/CD

This project includes GitHub Actions workflows for:
- Continuous Integration testing on all platforms
- Automated releases for desktop platforms
- Changelog generation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Tauri](https://tauri.app/) - For the lightweight application framework
- [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) - For the WebAssembly framework
- [Radzen](https://radzen.com/) - For the Blazor component library
- [.NET](https://dotnet.microsoft.com/) - For the core framework

---

Created with ❤️ by [Devstroop Team](https://github.com/devstroop)
