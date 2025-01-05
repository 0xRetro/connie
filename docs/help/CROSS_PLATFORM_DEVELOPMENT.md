# Cross-Platform Development Guide

Brief description of cross-platform development considerations and requirements for the Connie AI Assistant project.

## File Location
`docs/help/CROSS_PLATFORM_DEVELOPMENT.md`

## Key Patterns & Principles
- Platform-agnostic code first approach
- Platform-specific code isolation
- Consistent development environment
- Cross-platform testing strategy
- Release build management

## Responsibilities

Does:
- Define cross-platform development workflow
- Document platform-specific requirements
- Outline build and release processes
- Provide troubleshooting guides
- Specify testing requirements

Does Not:
- Replace platform-specific documentation
- Detail individual feature implementations
- Cover app store deployment
- Handle CI/CD setup

## Component Connections
- [x] Config Layer
  - [x] Environment
  - [x] Platform-specific configs
- [x] Service Layer
  - [x] Database (SQLite)
  - [x] Platform channels
- [x] State Layer
  - [x] Platform-specific state
- [x] UI Layer
  - [x] Platform-specific widgets
- [x] Util Layer
  - [x] Platform utilities

## Development Environment Setup

### Windows Development Machine
1. Requirements:
   - Windows 10 or later
   - Git for Windows
   - Flutter SDK
   - Android Studio
   - VS Code (recommended)
   - Windows 10 SDK

2. Environment Variables:
   ```
   FLUTTER_ROOT=[path to Flutter SDK]
   PATH=[add Flutter and Dart paths]
   ```

### Mac Development Machine
1. Requirements:
   - macOS Ventura or later
   - Xcode 14.0 or later
   - CocoaPods
   - Flutter SDK
   - VS Code (recommended)

2. Environment Setup:
   ```bash
   sudo xcode-select --install
   sudo gem install cocoapods
   flutter config --enable-macos-desktop
   ```

### macOS Architecture Considerations
1. Apple Silicon (M1/M2) vs Intel
   - macOS apps can target both arm64 (Apple Silicon) and x86_64 (Intel)
   - Warning about multiple matching destinations is normal
   - Default behavior uses native architecture (arm64 on M1/M2)

2. Specifying Architecture:
   ```bash
   # Force arm64 build
   flutter run --device-id=macos-arm64

   # Force x86_64 build
   flutter run --device-id=macos-x64
   ```

3. Universal Binary Builds:
   ```bash
   # Create universal binary (both architectures)
   flutter build macos --universal
   ```

4. Development Recommendations:
   - Test on both architectures if possible
   - Use universal builds for release
   - Consider architecture-specific optimizations
   - Monitor performance on both platforms

## Cross-Platform Development Workflow

### Initial Setup
1. Clone Repository:
   ```bash
   git clone [repository-url]
   cd connie
   flutter create .
   flutter pub get
   ```

2. Generate Code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Daily Development
1. Before Starting:
   ```bash
   git pull
   flutter clean
   flutter pub get
   flutter pub run build_runner build
   ```

   > **Important**: Always run the complete build process when switching between platforms or after
   > fresh checkouts. Many platform-specific issues (including SQLite warnings and architecture
   > warnings) are automatically resolved during the build process.

2. Platform-Specific Testing:
   ```bash
   # Windows
   flutter test --platform=windows
   flutter run -d windows

   # macOS
   flutter test --platform=macos
   flutter run -d macos
   ```

## SQLite Considerations

### Windows
- SQLite warnings are less strict
- Default path handling uses Windows conventions
- No special configuration needed

### macOS
- Stricter SQLite compiler warnings (can be ignored)
- Path handling uses POSIX conventions
- CocoaPods integration required
- Additional entitlements may be needed

## Platform-Specific Code

### Directory Structure
```
lib/
├── platforms/
│   ├── windows/
│   │   └── windows_specific.dart
│   └── macos/
│       └── macos_specific.dart
└── shared/
    └── platform_interface.dart
```

### Implementation Pattern
```dart
import 'dart:io' show Platform;

class PlatformService {
  void platformSpecificOperation() {
    if (Platform.isMacOS) {
      // macOS implementation
    } else if (Platform.isWindows) {
      // Windows implementation
    }
  }
}
```

## Build Process

### Windows Builds
- Must be built on Windows machine
- Commands:
  ```bash
  flutter build windows
  ```
- Output location: `build/windows/runner/Release/`

### macOS Builds
- Must be built on Mac machine
- Commands:
  ```bash
  flutter build macos
  ```
- Output location: `build/macos/Build/Products/Release/`

## Troubleshooting Guide

### Common Windows Issues
1. SQLite Integration
   - Solution: Ensure sqlite3.dll is in PATH
   - Check Windows SDK installation

2. Path Separators
   - Use path.join() for cross-platform compatibility
   - Avoid hardcoded separators

### Common macOS Issues
1. SQLite Warnings
   - Normal behavior on macOS
   - No functional impact
   - Can be ignored during development

2. CocoaPods
   - Run `pod install` in ios/ and macos/ directories
   - Keep CocoaPods updated

3. Entitlements
   - Check entitlements files for proper permissions
   - Update for specific features (camera, microphone, etc.)

## Testing Strategy

### Cross-Platform Tests
1. Unit Tests:
   ```dart
   group('Platform-agnostic tests', () {
     test('should work on all platforms', () {
       // Platform-independent test
     });
   });
   ```

2. Platform-Specific Tests:
   ```dart
   group('Platform-specific tests', () {
     test('should run on specific platform', () {
       if (Platform.isMacOS) {
         // macOS specific test
       }
     });
   });
   ```

## Additional Details

### Configuration
- Use platform-specific configuration files
- Maintain separate build configurations
- Handle platform-specific dependencies

### State Management
- Use platform-aware providers when needed
- Handle platform-specific state separately
- Maintain platform-agnostic state interfaces

### Services
- Implement platform-specific service interfaces
- Use dependency injection for platform services
- Handle platform-specific initialization

### UI Integration
- Use platform-specific widgets when necessary
- Maintain consistent UI across platforms
- Handle platform-specific layouts

### Utils
- Create platform-specific utilities when needed
- Use platform-check utilities
- Maintain shared utility interfaces 