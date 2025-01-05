# Project Structure

project-root/
├── .github/                     # GitHub-specific configurations
│   └── workflows/              # CI/CD (GitHub Actions) YAML files
├── android/                     # Android platform folder (auto-generated)
├── ios/                         # iOS platform folder (auto-generated)
├── linux/                       # Linux desktop support (auto-generated)
├── macos/                      # macOS desktop support (auto-generated)
├── windows/                    # Windows desktop support (auto-generated)
├── web/                        # Web support (auto-generated)
├── scripts/                    # Utility scripts (e.g., build, deploy)
├── docs/                       # Documentation
│   ├── concepts/              # Core concepts and technologies
│   │   ├── FLUTTER.md         # Flutter documentation
│   │   ├── DRIFT.md          # Drift database documentation
│   │   ├── SERVICES.md       # Services architecture documentation
│   │   ├── DOCUMENTATION.md  # Documentation standards
│   │   ├── LOGGING.md        # Logging architecture and patterns
│   │   └── GIT_WORKFLOW.md   # Git workflow documentation
│   ├── app/                  # Application-specific file documentation
│   │   ├── MAIN_DART.md      # main.dart documentation
│   │   ├── APP_PREFERENCES.md # app_preferences.dart documentation
│   │   ├── SETTINGS.md       # Settings implementation documentation
│   │   ├── LOGGER_CONFIG.md  # logger_config.dart documentation
│   │   ├── LOGGER_SERVICE.md # logger_service.dart documentation
│   │   ├── ENVIRONMENT.md    # environment.dart documentation
│   │   ├── PROVIDER_CONFIG.md # provider_config.dart documentation
│   │   └── DATABASE_INTEGRATION.md # Database integration patterns
│   ├── rules/                # Project rules and standards
│   │   ├── UI_STANDARDS.md   # UI development standards
│   │   ├── WIDGET_STANDARDS.md # Widget development standards
│   │   ├── PROVIDER_STANDARDS.md # Provider development standards
│   │   └── CODE_REVIEW.md    # Code review standards
│   ├── ui/                   # UI-related documentation
│   │   ├── screens/         # Screen-specific documentation
│   │   │   ├── MAIN_SCREEN.md # Main screen documentation
│   │   │   ├── SETTINGS_SCREEN.md # Settings screen documentation
│   │   │   ├── SETUP_WORKFLOW.md # Setup workflow documentation
│   │   │   └── PEOPLE_SCREEN.md # People screen documentation
│   │   ├── layout/          # Layout-related documentation
│   │   │   └── BASE_LAYOUT.md # Base layout documentation
│   │   └── widgets/         # Widget-related documentation
│   │       └── NAV_BAR.md   # NavBar widget documentation
│   ├── PROJECT_ROADMAP.md    # Project roadmap documentation
│   └── PROJECT_STRUCTURE.md  # Project structure documentation
├── test/                      # Unit & widget test files
│   └── database/             # Database-related tests
├── lib/
│   ├── config/               # App-wide configurations
│   │   ├── environment.dart  # Environment configuration
│   │   ├── logger_config.dart # Logger configuration
│   │   ├── provider_config.dart # Provider configuration
│   │   ├── app_preferences_config.dart # Preferences configuration
│   │   └── theme.dart       # App theming
│   ├── database/           # Database implementation
│   │   ├── tables/        # Table definitions
│   │   │   ├── people_table.dart
│   │   │   ├── ui_settings_table.dart
│   │   │   └── plugin_settings_table.dart
│   │   ├── daos/         # Data Access Objects
│   │   │   ├── app_dao.dart
│   │   │   └── dynamic_table_dao.dart
│   │   ├── models/       # Data models
│   │   │   ├── people.dart
│   │   │   ├── ui_settings.dart
│   │   │   └── plugin_settings.dart
│   │   └── database.dart # Main database class
│   ├── navigation/          # Routing configuration
│   │   └── app_router.dart  # Router configuration
│   ├── providers/           # Riverpod providers
│   │   ├── app_preferences_provider.dart # Preferences state management
│   │   ├── theme_provider.dart # Theme state management
│   │   ├── first_run_provider.dart # First run state management
│   │   └── people_provider.dart # People state management
│   ├── services/            # Business logic and services
│   │   ├── app_preferences.dart # App preferences service
│   │   ├── initialization_service.dart # Initialization service
│   │   ├── logger_service.dart # Logging service
│   │   ├── navigation_analytics_service.dart # Navigation analytics
│   │   └── setup_workflow_service.dart # Setup workflow service
│   ├── ui/                  # User interface components
│   │   ├── layout/         # Base layouts and responsive design
│   │   │   ├── base_layout.dart # Base layout implementation
│   │   │   ├── responsive_layout.dart # Responsive layout implementation
│   │   │   ├── color_palette.dart # Color definitions
│   │   │   ├── typography_styles.dart # Typography definitions
│   │   │   └── spacing_constants.dart # Spacing constants
│   │   ├── screens/        # Application screens
│   │   │   ├── main_screen.dart # Main screen
│   │   │   ├── settings_screen.dart # Settings screen
│   │   │   ├── setup_workflow_screen.dart # Setup workflow screen
│   │   │   ├── people_screen.dart # People management screen
│   │   │   └── error_screen.dart # Error screen
│   │   └── widgets/        # Reusable UI components
│   │       ├── nav_bar.dart # Navigation bar widget
│   │       ├── error_boundary.dart # Error boundary widget
│   │       ├── theme_settings_widget.dart # Theme settings widget
│   │       └── data_card.dart # Data card widget
│   ├── utils/              # Utility functions and helpers
│   │   ├── lifecycle_observer.dart # App lifecycle observer
│   │   └── initialization_progress.dart # Initialization progress tracking
│   └── main.dart           # Application entry point
├── pubspec.yaml            # Flutter & Dart dependencies
├── analysis_options.yaml   # Linting rules
├── .gitignore             # Git ignore patterns
└── README.md              # Project overview & usage instructions
