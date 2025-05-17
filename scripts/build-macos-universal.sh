#!/bin/bash
# Script to build a universal macOS binary for the Tauri app

set -e

# Check if we're on macOS
if [[ $(uname) != "Darwin" ]]; then
  echo "Error: This script must be run on macOS"
  exit 1
fi

echo "==== Building Universal macOS Binary ===="

# Ensure the Rust targets are installed
echo "Installing required Rust targets..."
rustup target add x86_64-apple-darwin aarch64-apple-darwin

# Build the Blazor app
echo "Building Blazor app..."
dotnet publish -c Release src/TauriBlazorBoilerplate.csproj -o dist

# Build the Tauri app with universal target
echo "Building Tauri universal binary..."
cd src-tauri
CARGO_PROFILE_RELEASE_LTO=true \
CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 \
CARGO_PROFILE_RELEASE_OPT_LEVEL=3 \
CARGO_PROFILE_RELEASE_PANIC="abort" \
CARGO_PROFILE_RELEASE_STRIP=true \
cargo tauri build --target universal-apple-darwin --verbose

echo "==== Universal macOS build complete! ===="
echo "Your universal binary can be found in src-tauri/target/universal-apple-darwin/release/bundle"
