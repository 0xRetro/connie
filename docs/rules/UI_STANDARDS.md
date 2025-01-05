# UI Standards and Best Practices

## Layout System

### Base Layout Structure
- Every screen MUST use either `BaseLayout` or `BaseScreenLayout`
- `BaseLayout`: For simple screens without async state
- `BaseScreenLayout`: For screens with loading/error states
- Proper title and navigation configuration is required

### Responsive Design
- All screens MUST be responsive using `ResponsiveLayout`
- Use breakpoints from `breakpoints.dart`:
  - Mobile: 0-599px
  - Tablet: 600-1023px
  - Desktop: 1024px+
  - Content min: 320px
  - Content max: 1200px
- Use `ResponsiveSpacing` for consistent spacing
- Use `ResponsiveConstraints` for width constraints
- Follow Material Design responsive patterns
- Test layouts at breakpoint boundaries

## Widget Hierarchy

### Custom Widgets
1. **MUST create custom widgets when:**
   - Widget is used in multiple places
   - Widget complexity exceeds 50 lines
   - Widget has specific business logic
   - Widget manages state

2. **Widget Organization:**
   ```
   lib/ui/
   ├── widgets/
   │   ├── common/           # Shared widgets
   │   ├── forms/            # Form-related widgets
   │   ├── cards/            # Card variations
   │   └── [feature]/        # Feature-specific widgets
   ```

### State Management
- Use `ConsumerWidget` for Riverpod integration
- Prefer `HookConsumerWidget` for complex state
- Keep state close to where it's used
- Use `AsyncValue` for loading/error states

## Styling Standards

### Typography
- Use `typography_styles.dart` definitions
- Follow Material Design type scale
- Maintain consistent text styles

### Colors
- Use `color_palette.dart` definitions
- Follow accessibility guidelines
- Maintain consistent theming

### Spacing
- Use `ResponsiveSpacing` constants
- Maintain consistent layout rhythm
- Follow 8dp grid system

## Screen Structure

### Required Components
1. **Screen Class:**
   ```dart
   class ExampleScreen extends ConsumerWidget {
     const ExampleScreen({super.key});

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       return BaseLayout(
         title: 'Example',
         child: ErrorBoundary(
           child: _buildContent(),
         ),
       );
     }

     Widget _buildContent() {
       // Screen-specific content
     }
   }
   ```

2. **Documentation:**
   - Purpose comment
   - Navigation requirements
   - State dependencies
   - Widget dependencies

### Error Handling
- Use `ErrorBoundary` widget for catching UI errors
- Implement retry functionality where applicable
- Use SelectableText for error messages
- Provide clear visual error indicators
- Log errors with stack traces
- Follow error display hierarchy:
  1. Critical errors: Full screen error display
  2. Component errors: In-place error boundary
  3. Form errors: Field-level validation
  4. Action errors: Snackbar/toast notifications

## Code Organization

### File Structure
```
lib/ui/screens/[feature]/
├── feature_screen.dart      # Main screen
├── widgets/                 # Screen-specific widgets
│   ├── feature_header.dart
│   └── feature_content.dart
└── providers/              # Screen-specific providers
    └── feature_provider.dart
```

### Naming Conventions
- Screens: `*_screen.dart`
- Widgets: `*_widget.dart`
- Providers: `*_provider.dart`
- Models: `*_model.dart`

## Performance Guidelines

### Widget Optimization
- Use `const` constructors
- Implement `shouldRebuild` when needed
- Use `ListView.builder` for long lists
- Cache expensive computations

### Image Handling
- Use appropriate image formats
- Implement proper caching
- Handle loading states
- Provide error fallbacks

## Testing Requirements

### Widget Tests
- Test widget rendering
- Test user interactions
- Test error states
- Test responsive behavior

### Integration Tests
- Test navigation flows
- Test state management
- Test error handling
- Test data loading

## Accessibility

### Requirements
- Proper semantic labels
- Sufficient contrast ratios
- Keyboard navigation support
- Screen reader compatibility
- Touch targets (48x48dp)

## Documentation

### Required Documentation
- Screen purpose and usage
- Widget dependencies
- State management approach
- Navigation requirements
- Error handling strategy

### Example Documentation Template
```dart
/// Screen that handles [purpose]
///
/// Navigation:
/// - Entry points: [list entry points]
/// - Exit points: [list exit points]
///
/// Dependencies:
/// - Providers: [list providers]
/// - Services: [list services]
/// - Widgets: [list custom widgets]
///
/// Error Handling:
/// - [describe error scenarios and handling]
```

## Review Checklist

Before submitting UI changes:
- [ ] Follows layout system guidelines
- [ ] Implements responsive design
- [ ] Uses custom widgets appropriately
- [ ] Follows styling standards
- [ ] Implements proper error handling
- [ ] Includes required documentation
- [ ] Passes performance guidelines
- [ ] Includes necessary tests
- [ ] Meets accessibility requirements 