# Code Review Standards

## Review Process

### 1. Pre-Review Checklist
- [ ] Code follows project structure
- [ ] Documentation is complete
- [ ] Tests are written and passing
- [ ] Linter shows no errors
- [ ] Proper error handling
- [ ] Performance considerations
- [ ] Security considerations

### 2. Review Scope
- Maximum 400 lines per review
- Break large changes into smaller PRs
- Group related changes together
- Include tests with changes

## Code Quality

### 1. Clean Code Principles
- Single Responsibility Principle
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple, Stupid)
- YAGNI (You Aren't Gonna Need It)

### 2. Code Style
```dart
// Good
class UserService {
  final Database _db;
  
  Future<User?> getUser(String id) async {
    try {
      return await _db.users.get(id);
    } catch (e) {
      logError(e);
      return null;
    }
  }
}

// Bad
class UserService {
  Database db; // Not final
  
  Future<User> getUser(String id) async { // No error handling
    return db.users.get(id);
  }
}
```

## Documentation Review

### 1. Required Documentation
- Class/method purpose
- Parameters and return types
- Error conditions
- Usage examples
- Dependencies

### 2. Quality Checks
- Clear and concise
- Up-to-date with code
- Proper grammar
- No TODOs without tickets
- Links to related docs

## Testing Review

### 1. Test Coverage
- Unit tests for logic
- Widget tests for UI
- Integration tests for flows
- Edge cases covered
- Error scenarios tested

### 2. Test Quality
```dart
// Good
test('user creation fails with invalid email', () {
  expect(
    () => User(email: 'invalid'),
    throwsA(isA<ValidationError>()),
  );
});

// Bad
test('user test', () { // Vague description
  final user = User('test');
  expect(user.email, 'test');
});
```

## Security Review

### 1. Data Safety
- Input validation
- SQL injection prevention
- XSS prevention
- Proper encryption
- Secure storage

### 2. Authentication
- Token handling
- Session management
- Permission checks
- Secure communication

## Performance Review

### 1. UI Performance
- Widget rebuilds minimized
- Proper list virtualization
- Image optimization
- Animation smoothness

### 2. Resource Usage
- Memory leaks
- Database queries
- Network calls
- File operations

## Review Comments

### 1. Comment Structure
```
[Type]: Description

Types:
- [Critical]: Must be fixed
- [Major]: Should be fixed
- [Minor]: Consider fixing
- [Nitpick]: Optional improvement
- [Question]: Needs clarification
```

### 2. Comment Quality
- Be specific and actionable
- Explain why, not just what
- Provide examples
- Be constructive
- Link to documentation

## Review Response

### 1. Author Responsibilities
- Address all critical/major issues
- Explain disagreements
- Update code promptly
- Request re-review when ready

### 2. Reviewer Responsibilities
- Review within 24 hours
- Be thorough but fair
- Focus on important issues
- Approve when satisfied

## Merge Criteria

### 1. Required Checks
- [ ] All tests passing
- [ ] Documentation complete
- [ ] No critical issues
- [ ] Code coverage maintained
- [ ] Performance verified

### 2. Optional Improvements
- Consider minor issues
- Note technical debt
- Track future improvements
- Document known limitations

## Post-Merge

### 1. Monitoring
- Watch for regressions
- Monitor performance
- Check error rates
- Verify functionality

### 2. Documentation
- Update changelogs
- Update API docs
- Note breaking changes
- Document migrations

## Review Checklist

Before approving changes:
- [ ] Code quality standards met
- [ ] Documentation complete
- [ ] Tests comprehensive
- [ ] Security verified
- [ ] Performance acceptable
- [ ] Comments addressed
- [ ] Merge criteria met 