# Widget Development Standards

## Widget Classification

### 1. Atomic Widgets
- Self-contained, single-purpose components
- No business logic
- Minimal state management
- Examples: buttons, inputs, icons

### 2. Composite Widgets
- Combine multiple atomic widgets
- May contain simple state
- No business logic
- Examples: cards, list items, form groups

### 3. Feature Widgets
- Implement specific feature functionality
- May contain business logic
- Can manage complex state
- Examples: data tables, forms, dialogs, error boundaries

### 4. Error Boundary Widgets
- Catch and handle UI rendering errors
- Provide consistent error display
- Support error recovery mechanisms
- Examples: ErrorBoundary, AsyncErrorBoundary

## Implementation Guidelines

### State Management
```dart
// Stateless when possible
class SimpleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SimpleButton({
    super.key,
    required this.onPressed,
    required this.label,
  });
}

// Use ConsumerWidget for Riverpod
class DataWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    // ...
  }
}

// Use HookConsumerWidget for complex state
class ComplexWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    // ...
  }
}
```

### Props Pattern
- Required vs Optional props clearly defined
- Default values when appropriate
- Proper type definitions
- Documentation for complex props

### Error Handling
- Use ErrorBoundary for UI error catching
- Graceful fallbacks for null/empty data
- Error states clearly defined
- Loading states implemented
- User feedback for actions
- Selectable error messages for copying

### Reusability
- Avoid hard-coded values
- Use theme and style tokens
- Accept customization props
- Follow composition pattern

## Documentation Requirements

### Widget Header
```dart
/// A reusable widget that [describe primary purpose]
///
/// Usage:
/// ```dart
/// MyWidget(
///   prop1: value1,
///   prop2: value2,
/// )
/// ```
///
/// Props:
/// - prop1: [description]
/// - prop2: [description]
///
/// Example:
/// ```dart
/// MyWidget(
///   prop1: 'value',
///   prop2: 42,
///   onTap: () => print('Tapped'),
/// )
/// ```
```

### Implementation Notes
- Document complex logic
- Explain state management
- Note dependencies
- List known issues
- Provide usage examples

### Testing Guidelines
- Unit tests for logic
- Widget tests for UI
- Integration tests for flows
- Document test cases
- Cover edge cases

## Performance Guidelines

### Optimization
- Use `const` constructors
- Implement `shouldRebuild`
- Minimize rebuilds
- Cache expensive computations

### Memory Management
- Dispose controllers
- Clean up subscriptions
- Handle image caching
- Manage scroll controllers

## Accessibility

### Requirements
- Semantic labels
- Sufficient contrast
- Touch targets (48x48dp)
- Keyboard navigation
- Screen reader support

## Review Checklist

Before submitting widget changes:
- [ ] Follows widget classification
- [ ] Proper state management
- [ ] Complete documentation
- [ ] Error handling implemented
- [ ] Tests written
- [ ] Accessibility verified
- [ ] Performance optimized
``` 