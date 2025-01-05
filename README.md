# Connie AI Assistant

Connie is an AI-powered assistant application that enables consistent processes, workflows, and task management across various domains, including business operations, personal life, finances, projects, and goals. The platform aims to provide a centralized way to manage and automate complex, context-rich data using a language model (LLM) and artificial intelligence (AI).

## Vision

The primary goal of Connie is to reduce manual overhead and streamline problem definition and action by leveraging AI to build complex solutions to nuanced problems consistently and easily. By centralizing data management and process automation, Connie enables users to focus on high-level objectives while the AI handles the details.

## Key Features

- Centralized data management across multiple domains
- Dynamic database schema management
- People and resource management
- Responsive UI design supporting desktop, tablet, and mobile
- Intelligent process automation and workflow optimization
- Contextual problem-solving and decision support
- Extensible architecture for adding new features and integrations
- Cross-platform compatibility (Windows, iOS, macOS, Android)

## Technical Stack

- Flutter/Dart for cross-platform UI development
- Riverpod for state management
- GoRouter for navigation
- Drift (SQLite) for local database management
- ResponsiveFramework for adaptive UI
- Material 3 design system
- LLM integration (planned)

## Project Structure

```
lib/
├── config/         # App-wide configurations
├── database/       # Database models and management
├── navigation/     # Routing configuration
├── providers/      # Riverpod providers
├── services/       # Business logic and services
└── ui/            # User interface components
    ├── layout/    # Base layouts and responsive design
    ├── screens/   # Application screens
    └── widgets/   # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- SQLite for local database
- For Mac Development:
  - Xcode (latest version) for iOS development
  - Android Studio for Android development
  - Homebrew (recommended for package management)
  - VS Code or IntelliJ IDEA (recommended IDEs)

### Mac Development Setup

> **Note**: If you encounter Ruby/CocoaPods issues during setup, please refer to our [Ruby and CocoaPods Setup Guide](docs/help/RUBY_COCOAPODS_SETUP.md).

1. Install Homebrew (if not installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Flutter using Homebrew:
   ```bash
   brew install flutter
   ```

3. Install development tools:
   ```bash
   # Install Xcode from the Mac App Store
   xcode-select --install
   sudo xcodebuild -license
   
   # Install Android Studio
   brew install --cask android-studio
   ```

4. Configure Flutter:
   ```bash
   flutter doctor
   # Follow any additional instructions from flutter doctor output
   ```

5. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/connie.git
   cd connie
   ```

6. Install dependencies:
   ```bash
   flutter pub get
   ```

7. Run the code generator:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

8. Start the application:
   ```bash
   flutter run
   ```

### IDE Setup (Recommended)
* Install the Flutter and Dart plugins from JetBrains marketplace

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/connie.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the code generator:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Start the application:
   ```bash
   flutter run
   ```

## Development

- Use `flutter pub run build_runner watch` during development for continuous code generation
- Follow the project roadmap in `docs/PROJECT_ROADMAP.md`
- Review documentation in `docs/` directory for architecture and concepts

## Contributing

We welcome contributions to help improve and expand Connie's capabilities. Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on how to contribute to the project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](./LICENSE.md) file for details. 