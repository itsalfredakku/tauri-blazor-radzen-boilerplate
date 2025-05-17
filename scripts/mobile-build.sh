#!/bin/zsh

# mobile-build.sh - Script to build the Tauri application for mobile platforms

# Parse command-line arguments
PLATFORM=""
BUILD_TYPE="debug"
RELEASE=false
VERBOSE=false
HELP=false
EMULATOR=false

for arg in "$@"; do
  case $arg in
    --android)
      PLATFORM="android"
      shift
      ;;
    --ios)
      PLATFORM="ios"
      shift
      ;;
    --release)
      RELEASE=true
      BUILD_TYPE="release"
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --emulator)
      EMULATOR=true
      shift
      ;;
    --help)
      HELP=true
      shift
      ;;
    *)
      # Unknown option
      echo "Unknown option: $arg"
      HELP=true
      ;;
  esac
done

# Show help
if [[ "$HELP" == true || -z "$PLATFORM" ]]; then
  echo "Mobile Build Script for Tauri + Blazor"
  echo "Usage: ./mobile-build.sh [options]"
  echo ""
  echo "Options:"
  echo "  --android   Build for Android"
  echo "  --ios       Build for iOS (macOS only)"
  echo "  --release   Build in release mode"
  echo "  --verbose   Show verbose output"
  echo "  --emulator  Run in emulator after build"
  echo "  --help      Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./mobile-build.sh --android             # Debug build for Android"
  echo "  ./mobile-build.sh --ios --release       # Release build for iOS"
  echo "  ./mobile-build.sh --android --emulator  # Debug build for Android and run in emulator"
  exit 0
fi

# Check platform requirements
if [[ "$PLATFORM" == "ios" && "$(uname)" != "Darwin" ]]; then
  echo "❌ iOS builds are only supported on macOS"
  exit 1
fi

# Set environment variables for faster builds
export CARGO_INCREMENTAL=0
export CARGO_NET_RETRY=10
export RUSTUP_MAX_RETRIES=10
export CARGO_TERM_COLOR=always

# Detect CPU cores for optimal parallel compilation
if [[ "$(uname)" == "Darwin" ]]; then
  CPU_CORES=$(sysctl -n hw.ncpu)
else
  CPU_CORES=$(nproc)
fi
OPTIMAL_JOBS=$((CPU_CORES > 1 ? CPU_CORES - 1 : 1))
export CARGO_BUILD_JOBS=$OPTIMAL_JOBS

echo "🚀 Building with $OPTIMAL_JOBS parallel jobs"

# Ensure Rust targets are installed
echo "🔄 Checking Rust targets..."
if [[ "$PLATFORM" == "android" ]]; then
  rustup target add aarch64-linux-android x86_64-linux-android
elif [[ "$PLATFORM" == "ios" ]]; then
  rustup target add aarch64-apple-ios x86_64-apple-ios
fi

# Build .NET project
echo "🔨 Building .NET project..."
BUILD_CONFIG="Release"
dotnet publish -c $BUILD_CONFIG src/TauriBlazorBoilerplate.csproj -o dist

# Check if .NET build succeeded
if [ $? -ne 0 ]; then
  echo "❌ .NET build failed"
  exit 1
fi

# Initialize platform if needed
if [[ ! -d "src-tauri/gen/$PLATFORM" ]]; then
  echo "📱 Initializing $PLATFORM platform..."
  cargo tauri $PLATFORM init
fi

# Build for the selected platform
echo "📱 Building for $PLATFORM..."
if [[ "$RELEASE" == true ]]; then
  echo "🔨 Creating release build..."
  
  # Add release-specific optimizations
  export CARGO_PROFILE_RELEASE_LTO=true
  export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
  export CARGO_PROFILE_RELEASE_OPT_LEVEL=3
  export CARGO_PROFILE_RELEASE_PANIC=abort
  
  cargo tauri $PLATFORM build
else
  if [[ "$EMULATOR" == true ]]; then
    echo "🔨 Creating debug build and running in emulator..."
    cargo tauri $PLATFORM dev
  else
    echo "🔨 Creating debug build..."
    cargo tauri $PLATFORM build --debug
  fi
fi

# Check if build succeeded
if [ $? -ne 0 ]; then
  echo "❌ $PLATFORM build failed"
  exit 1
fi

# Show output location
echo "✅ Build completed successfully!"
if [[ "$PLATFORM" == "android" ]]; then
  if [[ "$RELEASE" == true ]]; then
    echo "📦 Release APK is available at src-tauri/gen/android/app/build/outputs/apk/release/app-release.apk"
  else
    echo "📦 Debug APK is available at src-tauri/gen/android/app/build/outputs/apk/debug/app-debug.apk"
  fi
elif [[ "$PLATFORM" == "ios" ]]; then
  echo "📦 iOS build completed. Open the Xcode project at src-tauri/gen/ios/[AppName].xcworkspace to run or archive."
fi
