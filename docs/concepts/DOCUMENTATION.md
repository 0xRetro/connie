# Documentation Standards

This guide outlines the process for creating and reviewing documentation in the Connie AI Assistant project.

## File Documentation
Each file should have:
- Clear purpose statement
- File location
- Key patterns used
- Responsibilities (Does/Does Not)
- Component connections
- Dependencies & Management
    - When documenting files, explicitly track:
        - Direct dependencies (imports)
        - Provider dependencies
        - Navigation dependencies
        - Service dependencies
        - Widget dependencies
- Integration points
- Before modifying files:
    - Check component connections
    - Review provider dependencies
    - Verify navigation flows
    - Test service integrations
    - Update affected documentation
- Additional details

1. **Creating Documentation**
   - Create a new .md file in the appropriate docs directory
   - Use the template structure below
   - Focus on explaining "why" over "how"
   - Keep explanations concise and reference code instead of duplicating
   - Include all required sections
   - Check off all applicable requirements

2. **Reviewing Documentation**
   - Verify all required sections are present
   - Ensure dependencies and integration points are accurate
   - Validate that responsibilities are clearly defined
   - Check that all relevant checkboxes are marked
   - Verify format consistency
   - Test any included links

3. **Maintaining Documentation**
   - Update docs when corresponding code changes
   - Mark outdated sections with TODO comments
   - Review docs during code reviews
   - Keep dependencies and integration lists current

## Document Template

```markdown
# Component Name

Brief description of what this component does and why it exists.

## File Location
`lib/path/to/file.dart`

## Key Patterns & Principles
- Design patterns used (e.g., Singleton, Factory, Observer)
- Architecture principles followed
- Code organization strategies
- Important conventions

## Responsibilities
Does:
- Primary purpose
- Key functionalities
- Core features

Does Not:
- What's handled elsewhere
- Out of scope functionality
- Delegated responsibilities

## Component Connections
- [ ] Config Layer
  - [ ] Theme
  - [ ] Routes
  - [ ] Environment
  - [ ] Constants
- [ ] Service Layer
  - [ ] Database
  - [ ] API
  - [ ] Logger
  - [ ] Initialization
- [ ] State Layer
  - [ ] Providers
  - [ ] Notifiers
  - [ ] Models
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layouts
- [ ] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [ ] Types

## Execution Pattern
- [ ] Has Initialization Order
  If checked, detail the sequence:
  1. First step
  2. Second step
  3. etc.

- [ ] Has No Specific Order
  If checked, list independent operations:
  - Operation A
  - Operation B
  - etc.

## Dependencies
- `package_name`: Purpose of this dependency
- `another_package`: Why it's needed

## Integration Points
- `path/to/file.dart`: How they interact
- `another/file.dart`: Nature of dependency

## Additional Details

### Configuration (if using config layer)
- Required setup
- Default values
- Configuration points

### State Management (if using state layer)
- Providers used/exposed
- State update patterns
- Data flow

### Services (if using service layer)
- Service initialization
- Error handling
- Logging strategy

### UI Integration (if using UI layer)
- Widget tree position
- Screen flow
- Layout considerations

### Utils (if using util layer)
- Helper functions
- Extension methods
- Type definitions
```

## Format Rules
- Use consistent markdown formatting
- Keep line length under 100 characters
- Use appropriate code block language tags
- Use relative links to other docs
- Maintain consistent section ordering

## Review Checklist
- [ ] Title and description are clear and concise
- [ ] Key patterns & principles are documented
- [ ] Responsibilities are well-defined
- [ ] Component connections are accurately marked
- [ ] Execution pattern is specified if applicable
- [ ] Dependencies are accurately listed
- [ ] Integration points are verified
- [ ] Additional details match component connections
- [ ] Format is consistent
- [ ] Links are valid 