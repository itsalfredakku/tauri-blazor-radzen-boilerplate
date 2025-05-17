# Tauri + Blazor + Radzen - Boilerplate

<div align="center" style="display: flex; justify-content: center; align-items: center; gap: 30px; margin: 20px 0;">
  <img src="src/wwwroot/images/tauri.svg" alt="Tauri" width="150" />
  <img src="src/wwwroot/images/blazor.png" alt="Blazor" width="150" />
  <img src="src/wwwroot/images/radzen.png" alt="Radzen" width="150" />
</div>

A modern, lightweight desktop application boilerplate combining the power of [Tauri](https://tauri.app/), [Blazor WebAssembly](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor), and [Radzen](https://blazor.radzen.com/).

## Features

- **Lightweight Desktop Framework**: Tauri offers much smaller bundle sizes compared to Electron
- **Blazor WebAssembly**: Build interactive web UIs with C# instead of JavaScript
- **Secure by Default**: Harnesses Tauri's security-focused architecture
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Radzen Components**: Beautiful UI components from Radzen
- **Material 3 Design**: Modern design system with light/dark mode support
- **Built with .NET 9.0**: Leverages the latest .NET features

## Getting Started

### Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Rust](https://www.rust-lang.org/tools/install)
- [Node.js](https://nodejs.org/) (for NPM)
- [Tauri Prerequisites](https://tauri.app/v1/guides/getting-started/prerequisites) for your platform

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

3. Run the development server:

```bash
cargo tauri dev
```

This will:
- Start the Blazor WebAssembly development server
- Build and run the Tauri application
- Enable hot reloading for both frontend and backend changes

### VS Code Development

For the best development experience in VS Code:

1. Open the repository in VS Code
2. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```
3. Use the integrated debugging features:
   - **Debug Tauri Application**: F5 or Run → Start Debugging → "Tauri: Boilerplate Debug"
   - **Debug Blazor Only**: Run → Start Debugging → "Blazor: Boilerplate Debug"
   - **Attach to Running WebAssembly**: Run → Start Debugging → "Attach to Blazor WebAssembly"

### Build & Run

This project includes optimized build scripts to speed up development and compilation:

```bash
# Run the optimized build script
./scripts/fast-build.sh

# For release build
./scripts/fast-build.sh --release

# Clean and rebuild everything
./scripts/fast-build.sh --clean --release
```

### Development

```bash
# Start in development mode
cargo tauri dev
```

### Optimize Rust Compilation (Optional)

To optimize Rust compilation for your specific machine:

```bash
# Run the optimization script
./scripts/optimize-rust.sh
```

### Building for Production

Build a production-ready application:

```bash
cargo tauri build
```

Your compiled application will be available in the `src-tauri/target/release/bundle` directory.

## Performance Optimizations

### Rust Compilation Optimizations
This project includes several optimizations to speed up Rust compilation:

- **Cargo Configuration**: Custom `.cargo/config.toml` with optimized settings
- **Rust Toolchain Control**: Specific toolchain requirements in `rust-toolchain.toml`
- **CI/CD Optimizations**: Efficient caching and build configurations
- **Release Build Tuning**: Optimized release compilation flags for smaller, faster binaries

### Development Workflow Optimizations
- Incremental compilation settings for faster dev cycles
- Efficient Node.js and .NET dependencies caching
- Parallel compilation enabled by default

## Project Structure

```
/
├── src/                  # Blazor WebAssembly application source code
│   ├── Components/       # Reusable Blazor components
│   ├── Layout/           # Application layout components
│   ├── Pages/            # Application pages
│   ├── Services/         # Services for theme, version, etc.
│   └── wwwroot/          # Static web assets
└── src-tauri/           # Tauri application source code
    ├── src/             # Rust source code for the Tauri application
    │   ├── lib.rs       # Core Tauri functionality
    │   └── main.rs      # Application entry point
    ├── Cargo.toml       # Rust dependencies
    └── tauri.conf.json  # Tauri configuration
```

## Features Included

### 1. Theme Management
- Light/Dark mode toggle
- Multiple theme options
- Persistent theme settings

### 2. Tauri API Examples
- Native dialogs
- File system access
- Window management
- System information

### 3. Error Handling
- Global error handler
- Error notifications
- Console logging

### 4. Loading Indicators
- Application loading spinner
- Operation indicators

### 5. Responsive Design
- Works on various screen sizes
- Mobile-friendly UI

### 6. CI/CD Workflows
- Continuous Integration with GitHub Actions
- Automated releases for Windows, macOS, and Linux
- Automated changelog generation

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

- [Tauri](https://tauri.app/) - For the lightweight desktop framework
- [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) - For the WebAssembly framework
- [Radzen](https://radzen.com/) - For the Blazor component library
- [.NET](https://dotnet.microsoft.com/) - For the core framework

---

Created with ❤️ by [DevsTroop](https://github.com/devstroop)
