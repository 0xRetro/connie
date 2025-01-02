project-root/
├── .github/                     # GitHub-specific configurations
│   └── workflows/              # CI/CD (GitHub Actions) YAML files
├── android/                     # Android platform folder (auto-generated)
├── ios/                         # iOS platform folder (auto-generated)
├── linux/                       # Linux desktop support (auto-generated)
├── macos/                       # macOS desktop support (auto-generated)
├── windows/                     # Windows desktop support (auto-generated)
├── web/                         # Web support (auto-generated)
├── scripts/                     # Utility scripts (e.g., build, deploy)
├── docs/                        # Documentation
│   ├── concepts/               # Core concepts and technologies
│   │   └── FLUTTER.md          # Flutter documentation
│   │   └── MATERIAL_APP.md     # MaterialApp documentation
│   ├── app/                    # Application-specific file documentation
│   │   └── PUBSPEC_YAML.md      # pubspec.yaml documentation
│   │   └── PUBSPEC_LOCK.md      # pubspec.lock documentation
│   │   └── CONNIE_IML.md        # connie.iml documentation
│   │   └── ANALYSIS_OPTIONS_YAML.md # analysis_options.yaml documentation
│   │   └── MAIN_DART.md         # main.dart documentation
│   ├── navigation/             # Navigation-related documentation
│   │   └── APP_ROUTER.md       # App router documentation
│   ├── screens/                # Screen-related documentation
│   │   └── MAIN_SCREEN.md      # Main screen documentation
│   ├── widgets/                # Widget-related documentation
│   │   └── CUSTOM_BUTTON.md    # Custom button documentation
│   ├── GIT_WORKFLOW.md         # Git workflow documentation
│   ├── PROJECT_ROADMAP.md      # Project roadmap documentation
│   └── PROJECT_STRUCTURE.md    # Project structure documentation
├── test/                        # Unit & widget test files
├── lib/
│   ├── navigation/              # Navigation-related files (e.g., app_router.dart)
│   ├── api/                     # Classes/functions for API calls (LLM, REST endpoints)
│   ├── config/                  # Global config/constants, environment setup
│   ├── database/                # Supabase and DB logic (queries, migrations, etc.)
│   ├── models/                  # Freezed data models, JSON serialization
│   ├── plugins/                 # Each plugin (Email, Bookkeeping, etc.) in its own folder
│   │   ├── email/
│   │   │   ├── email_provider.dart
│   │   │   ├── email_service.dart
│   │   │   └── email_ui.dart
│   │   └── bookkeeping/
│   │       ├── bookkeeping_provider.dart
│   │       ├── bookkeeping_service.dart
│   │       └── bookkeeping_ui.dart
│   ├── services/                # Business logic & orchestrator
│   │   ├── orchestrator_service.dart
│   │   └── other_shared_services.dart
│   ├── ui/                      # Flutter UI code (screens, widgets)
│   │   ├── screens/             # Individual screen files
│   │   │   └── main_screen.dart
│   │   ├── chat/
│   │   │   ├── chat_screen.dart
│   │   │   └── chat_widgets.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   └── shared/
│   │       └── widgets/         # Reusable UI components
│   │           └── custom_button.dart
│   ├── utils/                   # Utility functions/helpers (formatters, validators, etc.)
│   └── main.dart                # Application entry point
├── pubspec.yaml                 # Flutter & Dart dependencies
├── analysis_options.yaml        # Linting rules (if any)
├── .gitignore                   # Git ignore patterns
└── README.md                    # Project overview & usage instructions
