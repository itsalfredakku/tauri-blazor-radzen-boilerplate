# MacOS Universal Binary Build Process

This document explains how macOS universal binary builds work in this project.

## Overview

A universal macOS binary contains code for both Intel (x86_64) and Apple Silicon (arm64/aarch64) architectures, allowing the application to run natively on both types of Macs.

## How it Works

In our project, we use the special `universal-apple-darwin` target to create universal binaries. This is not a standard Rust target, but a Tauri-specific configuration that:

1. Builds the application for both `x86_64-apple-darwin` (Intel Macs) and `aarch64-apple-darwin` (Apple Silicon Macs)
2. Combines both into a universal binary using macOS's `lipo` tool

## Build Options

There are several ways to build universal macOS binaries in this project:

### Using VS Code Tasks

We provide two convenient VS Code tasks:

1. **build-macos-universal** - A comprehensive build script that handles all aspects of building universal binaries
   - Access via: Terminal > Run Task... > build-macos-universal

2. **fast-build-universal** - A faster version that uses optimized settings
   - Access via: Terminal > Run Task... > fast-build-universal

### Using Shell Scripts

You can directly run our build scripts:

```bash
# Full universal build process
./scripts/build-macos-universal.sh

# Fast build with universal target
./scripts/fast-build.sh --universal

# Fast build with universal target and release optimizations
./scripts/fast-build.sh --universal --release
```

## CI/CD Configuration

In our GitHub Actions workflow:

1. We install both individual architecture targets:
   - `x86_64-apple-darwin`
   - `aarch64-apple-darwin`

2. We use the `universal-apple-darwin` flag when invoking `cargo tauri build`

## Local Development

For local development and testing of universal builds:

1. Ensure both targets are installed:
   ```bash
   rustup target add x86_64-apple-darwin aarch64-apple-darwin
   ```

2. Build using the universal target:
   ```bash
   cargo tauri build --target universal-apple-darwin
   ```

## Troubleshooting

If you encounter issues with universal builds:

1. Verify both required targets are installed:
   ```bash
   rustup target list --installed
   ```

2. Try building for individual targets separately to isolate issues:
   ```bash
   cargo tauri build --target x86_64-apple-darwin
   cargo tauri build --target aarch64-apple-darwin
   ```

3. Check that you're running on macOS, as universal builds are only supported on macOS systems.
