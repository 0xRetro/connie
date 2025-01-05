# SystemInfoCard Widget

## Overview
The `SystemInfoCard` widget provides a comprehensive display of system, environment, and application information in a read-only format. It's designed to be used in settings or diagnostic screens to show relevant system and configuration details.

## File Location
`lib/ui/widgets/system_info_card.dart`

## Key Patterns

### Information Categories
1. Environment Information
   - Development/Production mode
   - Environment name
   - Debug info status
   - File logging status
   - Analytics status
   - Logs directory location (non-web)

2. Application Information
   - Application version
   - API endpoint
   - Platform details
   - OS version (non-web)
   - Dart version
   - Build mode (Debug/Profile/Release)

3. System Resources
   - Current locale
   - Text scale factor
   - Screen dimensions
   - Device pixel ratio
   - Platform brightness

4. Database Information
   - Maximum connections
   - Cache status
   - Query logging
   - Storage path
   - Backup status
   - Database file location (non-web)
   - Actual database name from Environment

## Component Responsibilities

### Primary Functions
- Display system information in organized sections
- Handle null values safely
- Format technical information for readability
- Provide selectable text for copying values
- Support both web and native platforms
- Handle platform-specific information gracefully
- Display file system paths for logs and database
- Show actual database configuration

### Error Handling
- Safe handling of null configuration values
- Platform-specific API error catching
- Empty section handling
- Graceful fallbacks for unavailable information
- Async path resolution error handling
- Directory access error handling

## Dependencies

### Imports
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform, Directory;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
```

### Internal Dependencies
- Environment configuration
- Typography styles
- Spacing constants
- Layout constants
- Database configuration

## Integration Points

### Parent Components
- Settings screen
- Debug information screens
- System diagnostics views

### Configuration Access
```dart
// Get database name from environment
final dbName = Environment.databaseName;

// Get database path
final dbPath = path.join(appDir.path, 'databases', dbName);
```

## UI Components

### Layout Structure
```
Card
└── Padding
    └── Column
        ├── Title
        ├── Environment Section (with logs path)
        ├── Application Section
        ├── System Resources Section
        └── Database Section (with DB file path)
```

### Styling
- Uses standard card elevation and padding
- Consistent spacing between sections
- Right-aligned values
- Selectable text for copying
- Responsive to screen width
- Platform-specific path formatting

## Testing Requirements

### Unit Tests
- Verify section visibility logic
- Test null handling
- Validate platform detection
- Check formatting functions
- Test path resolution
- Verify async loading states
- Test database name retrieval

### Widget Tests
- Render in different environments
- Verify all sections display
- Test selectable text
- Validate layout constraints
- Check path display format
- Test error states
- Verify database information

### Integration Tests
- Verify with different configurations
- Test platform-specific behavior
- Check error boundary integration
- Validate file path accuracy
- Test directory existence
- Verify database name accuracy

## Accessibility

### Requirements
- Selectable text for all values
- Sufficient contrast ratios
- Proper semantic labels
- Screen reader support
- Clear path representation

### Implementation
- Uses semantic labels
- Maintains readable text sizes
- Provides clear section hierarchy
- Supports text scaling
- Handles long paths gracefully

## Performance

### Optimizations
- Conditional rendering of sections
- Efficient null checking
- Minimal rebuilds
- Lightweight platform checks
- Async path resolution
- Cached directory paths
- Efficient database name access

### Considerations
- Memory usage for large configurations
- Platform API call efficiency
- Text rendering performance
- Layout calculation impact
- File system access timing
- Path resolution overhead
- Database configuration access

## Future Improvements

### Short Term
- Add memory usage information
- Include network status
- Show storage space details
- Add package version information
- Add directory existence checks
- Include file sizes
- Show database size

### Long Term
- Real-time resource monitoring
- Expandable sections
- Export functionality
- Custom section configuration
- Directory browsing capability
- Path modification options
- Database metrics display

## Common Issues

### Known Limitations
- Some values may be unavailable on web
- Platform-specific information varies
- Database information depends on configuration
- Some metrics require additional packages
- Path formats vary by platform
- Directory access may be restricted

### Troubleshooting
1. Missing Values
   - Check Environment configuration
   - Verify platform support
   - Validate database configuration
   - Check directory permissions
   - Verify path resolution
   - Confirm database name access

2. Layout Issues
   - Ensure proper parent constraints
   - Check text scaling factors
   - Verify screen dimensions
   - Handle long path wrapping
   - Test path overflow
   - Validate database path display

## Maintenance

### Regular Tasks
- Update platform detection logic
- Review error handling
- Update formatting patterns
- Check for deprecated APIs
- Verify path resolution
- Test directory access
- Validate database configuration

### Documentation Updates
- Keep section list current
- Update usage examples
- Document new features
- Maintain troubleshooting guide
- Document platform differences
- Update path formats
- Document database configuration 