#!/bin/zsh

# run-project.sh - A helper script to run the Tauri Blazor Boilerplate project

# Parse command-line arguments
DEV_MODE=true
CLEAN=false
VERBOSE=false
HELP=false

for arg in "$@"; do
  case $arg in
    --release)
      DEV_MODE=false
      shift
      ;;
    --clean)
      CLEAN=true
      shift
      ;;
    --verbose)
      VERBOSE=true
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
if [[ "$HELP" == true ]]; then
  echo "Run Project Script for Tauri + Blazor"
  echo "Usage: ./run-project.sh [options]"
  echo ""
  echo "Options:"
  echo "  --release   Run in release mode (default: dev mode)"
  echo "  --clean     Clean before running"
  echo "  --verbose   Show verbose output"
  echo "  --help      Show this help message"
  exit 0
fi

# Determine project location
PROJECT_PATH="src/TauriBlazorBoilerplate.csproj"
if [ ! -f "$PROJECT_PATH" ]; then
  echo "❌ Error: Project file not found at $PROJECT_PATH"
  echo "Make sure you're running this script from the root of the repository"
  exit 1
fi

# Clean if requested
if [[ "$CLEAN" == true ]]; then
  echo "🧹 Cleaning previous build artifacts..."
  rm -rf ./dist
  rm -rf ./src/bin
  rm -rf ./src/obj
  
  if [[ -d "./src-tauri/target" ]]; then
    echo "🧹 Cleaning Rust target directory..."
    cargo clean --manifest-path=./src-tauri/Cargo.toml
  fi
fi

# Set up environment variables for better performance
export CARGO_INCREMENTAL=0
export CARGO_NET_RETRY=10
export RUSTUP_MAX_RETRIES=10
export CARGO_TERM_COLOR=always

# Detect CPU cores for optimal parallel compilation
CPU_CORES=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)
OPTIMAL_JOBS=$((CPU_CORES > 1 ? CPU_CORES - 1 : 1))
export CARGO_BUILD_JOBS=$OPTIMAL_JOBS

echo "🚀 Setting up with $OPTIMAL_JOBS parallel jobs"

# Restore .NET dependencies
echo "📦 Restoring .NET dependencies..."
dotnet restore "$PROJECT_PATH"

if [ $? -ne 0 ]; then
  echo "❌ Failed to restore .NET dependencies"
  exit 1
fi

# Run the application
if [[ "$DEV_MODE" == true ]]; then
  echo "🚀 Starting in development mode..."
  cargo tauri dev $([ "$VERBOSE" == true ] && echo "--verbose")
else
  echo "🏗️ Building release version..."
  
  echo "📦 Publishing .NET project..."
  dotnet publish -c Release "$PROJECT_PATH" -o dist
  
  if [ $? -ne 0 ]; then
    echo "❌ Failed to publish .NET project"
    exit 1
  fi
  
  echo "📦 Building Tauri application..."
  (cd src-tauri && cargo tauri build $([ "$VERBOSE" == true ] && echo "--verbose"))
  
  if [ $? -ne 0 ]; then
    echo "❌ Failed to build Tauri application"
    exit 1
  fi
  
  echo "✅ Build completed successfully!"
  
  # Determine platform and show output location
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📦 Application bundle is available at: src-tauri/target/release/bundle/macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "📦 Application bundle is available at: src-tauri/target/release/bundle/appimage"
  elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* || "$OSTYPE" == "win32" ]]; then
    echo "📦 Application bundle is available at: src-tauri/target/release/bundle/msi"
  fi
fi
