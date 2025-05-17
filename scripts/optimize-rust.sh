#!/bin/zsh

# optimize-rust.sh - Script to optimize Rust compilation for this project

# Detect CPU cores and set optimal number of jobs
CPU_CORES=$(sysctl -n hw.ncpu || nproc || echo 4)
OPTIMAL_JOBS=$((CPU_CORES > 1 ? CPU_CORES - 1 : 1))

echo "🔍 Detecting system: $(uname -s) with $CPU_CORES CPU cores"
echo "🚀 Configuring Rust compilation for optimal performance..."

# Create or update .cargo/config.toml
mkdir -p .cargo
CONFIG_FILE=".cargo/config.toml"

cat > $CONFIG_FILE << EOL
# Auto-generated optimized Cargo config for this machine
# Generated on: $(date)

[build]
# Optimized for this machine with $CPU_CORES cores
jobs = $OPTIMAL_JOBS

[profile.dev]
opt-level = 1
debug = 0
split-debuginfo = "unpacked"
incremental = true
codegen-units = ${OPTIMAL_JOBS}

[profile.release]
opt-level = 3
lto = "thin"
codegen-units = 1
panic = "abort"
strip = true

[net]
retry = 10
git-fetch-with-cli = true

[term]
color = "always"
EOL

echo "✅ Created optimized Cargo config at $CONFIG_FILE"

# Optionally clean the target directory for a fresh start
if [[ "$1" == "--clean" ]]; then
  echo "🧹 Cleaning target directory for fresh compilation..."
  cargo clean
fi

# Apply any system-specific optimizations
case "$(uname -s)" in
  Darwin*)
    # macOS-specific optimizations
    echo "🍎 Adding macOS-specific optimizations..."
    echo "build --target-dir=target/darwin-cache" >> $CONFIG_FILE
    ;;
  Linux*)
    # Linux-specific optimizations
    echo "🐧 Adding Linux-specific optimizations..."
    echo "build --target-dir=target/linux-cache" >> $CONFIG_FILE
    ;;
  MINGW*|MSYS*|CYGWIN*)
    # Windows-specific optimizations
    echo "🪟 Adding Windows-specific optimizations..."
    echo "build --target-dir=target/windows-cache" >> $CONFIG_FILE
    ;;
esac

echo "🔧 Recommended build command: cargo build -Z unstable-options --keep-going"
echo "🔧 For release builds: cargo build --release"

echo "✨ Rust optimization complete! Your builds should now be faster."
