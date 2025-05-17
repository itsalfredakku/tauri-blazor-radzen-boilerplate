# Tauri + Blazor Boilerplate

![Tauri + Blazor](src/wwwroot/images/tauri.svg)

A modern, lightweight desktop application boilerplate combining the power of [Tauri](https://tauri.app/) and [Blazor WebAssembly](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor).

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

### Building for Production

Build a production-ready application:

```bash
cargo tauri build
```

Your compiled application will be available in the `src-tauri/target/release/bundle` directory.

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
