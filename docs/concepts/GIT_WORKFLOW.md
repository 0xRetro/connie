# Git Workflow

This document outlines the Git workflow for the Connie AI Assistant project and keeps track of the changes made to the project.

## Branching Strategy

- `main` branch: Represents the stable, production-ready code.
- `develop` branch: Represents the latest development code, where new features and bug fixes are merged.
- Feature branches: Branches created for developing new features, prefixed with `feature/`, e.g., `feature/chat-interface`.
- Bug fix branches: Branches created for fixing bugs, prefixed with `bugfix/`, e.g., `bugfix/login-issue`.

## Commit Message Convention

- Use descriptive and concise commit messages.
- Prefix commit messages with the type of change:
  - `feat:` for new features
  - `fix:` for bug fixes
  - `docs:` for documentation updates
  - `refactor:` for code refactoring
  - `style:` for code style changes
  - `test:` for adding or updating tests
  - `chore:` for other non-code changes (e.g., configuration, dependencies)

## Change Log

### [Unreleased]

#### Added
- Set up project structure and development environment
- Installed and configured necessary dependencies (Flutter, Dart, etc.)
- Set up version control (Git) and created a repository
- Added `.gitignore` file to exclude unnecessary files from version control
- Created `docs/GIT_WORKFLOW.md` to document the Git workflow and track changes

#### Changed
- Updated `pubspec.yaml` with required dependencies (`riverpod`, `freezed`, `supabase_flutter`)
- Updated `PROJECT_ROADMAP.md` to mark completed tasks in Phase 1

### [1.0.0] - 2023-05-25
- Initial project setup 