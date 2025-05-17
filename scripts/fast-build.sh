#!/bin/zsh

# fast-build.sh - Script to build the Tauri application with optimized settings

# Detect if we're in a CI environment
if [[ -n "$CI" ]]; then
  IS_CI=true
else
  IS_CI=false
fi

# Parse command-line arguments
CLEAN=false
RELEASE=false
VERBOSE=false
HELP=false
UNIVERSAL=false
TARGET=""

for arg in "$@"; do
  case $arg in
    --clean)
      CLEAN=true
      shift
      ;;
    --release)
      RELEASE=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --universal)
      UNIVERSAL=true
      shift
      ;;
    --help)
      HELP=true
      shift
      ;;
    --target=*)
      TARGET="${arg#*=}"
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
if [[ "$HELP" == true ]]; then
  echo "Fast Build Script for Tauri + Blazor"
  echo "Usage: ./fast-build.sh [options]"
  echo ""
  echo "Options:"
  echo "  --clean     Clean build artifacts before building"
  echo "  --release   Build in release mode"
  echo "  --verbose   Show verbose output"
  echo "  --target=*  Specify a target (e.g. --target=x86_64-apple-darwin)"
  echo "  --universal Build universal macOS binary (macOS only)"
  echo "  --help      Show this help message"
  exit 0
fi

# Set environment variables for faster builds
export CARGO_INCREMENTAL=0
export CARGO_NET_RETRY=10
export RUSTUP_MAX_RETRIES=10
export CARGO_TERM_COLOR=always

# Detect CPU cores for optimal parallel compilation
CPU_CORES=$(sysctl -n hw.ncpu || nproc || echo 4)
OPTIMAL_JOBS=$((CPU_CORES > 1 ? CPU_CORES - 1 : 1))
export CARGO_BUILD_JOBS=$OPTIMAL_JOBS

echo "🚀 Building with $OPTIMAL_JOBS parallel jobs"

# Clean if requested
if [[ "$CLEAN" == true ]]; then
  echo "🧹 Cleaning previous build artifacts..."
  rm -rf ./dist
  cargo clean --manifest-path=./src-tauri/Cargo.toml
fi

# Build .NET project
echo "🔨 Building .NET project..."
if [[ "$RELEASE" == true ]]; then
  BUILD_CONFIG="Release"
else
  BUILD_CONFIG="Debug"
fi

dotnet publish -c $BUILD_CONFIG src/TauriBlazorBoilerplate.csproj -o dist

# Check if .NET build succeeded
if [ $? -ne 0 ]; then
  echo "❌ .NET build failed"
  exit 1
fi

# Build Tauri project
echo "🔨 Building Tauri project..."
CARGO_ARGS=""

if [[ "$RELEASE" == true ]]; then
  CARGO_ARGS="build --release"
  # Add release-specific optimizations
  export CARGO_PROFILE_RELEASE_LTO=true
  export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
  export CARGO_PROFILE_RELEASE_OPT_LEVEL=3
  export CARGO_PROFILE_RELEASE_PANIC=abort
else
  CARGO_ARGS="build"
  # Add dev-specific optimizations
  export CARGO_PROFILE_DEV_DEBUG=0
  export CARGO_PROFILE_DEV_SPLIT_DEBUGINFO=unpacked
  export CARGO_PROFILE_DEV_OPT_LEVEL=1
fi

if [[ -n "$TARGET" ]]; then
  CARGO_ARGS="$CARGO_ARGS --target $TARGET"
elif [[ "$UNIVERSAL" == true ]]; then
  # Check if we're on macOS for universal builds
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ Universal builds are only supported on macOS"
    exit 1
  fi
  
  # Ensure both required targets are installed
  echo "🔄 Checking Rust targets for universal build..."
  rustup target add x86_64-apple-darwin aarch64-apple-darwin
  
  CARGO_ARGS="$CARGO_ARGS --target universal-apple-darwin"
fi

if [[ "$VERBOSE" == true ]]; then
  CARGO_ARGS="$CARGO_ARGS --verbose"
fi

# Run the build
echo "📦 Running: cargo tauri $CARGO_ARGS"
(cd src-tauri && cargo tauri $CARGO_ARGS)

# Check if Tauri build succeeded
if [ $? -ne 0 ]; then
  echo "❌ Tauri build failed"
  exit 1
fi

echo "✅ Build completed successfully!"
if [[ "$RELEASE" == true ]]; then
  echo "📦 Release artifacts are available in src-tauri/target/release"
else
  echo "📦 Debug artifacts are available in src-tauri/target/debug"
fi
