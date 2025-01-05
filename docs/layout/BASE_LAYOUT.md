# Base Layout

The `base_layout.dart` file contains the `BaseLayout` widget, which serves as the foundation for the app's layout. It provides a consistent structure and styling across all screens in the Connie AI Assistant app.

## File Location

`lib/ui/layout/base_layout.dart`

## Description

The `BaseLayout` widget is a `StatelessWidget` that defines the basic structure and styling of the app's screens. It includes the following components:

- `ResponsiveLayout`: Ensures that the layout is responsive and adapts to different screen sizes.
- `Scaffold`: The main structure of the screen, which provides an app bar and a body.
- `NavBar`: A custom app bar widget that displays the app's navigation options (e.g., "Home" and "Settings").
- `Padding`: Adds consistent spacing around the screen's content using the `kSpacingMedium` constant.

The `BaseLayout` widget takes a `child` parameter, which represents the content of the screen. It wraps the child widget with the necessary layout components and styling.

## Usage

To use the `BaseLayout` widget, wrap your screen's content with it:

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: // Your screen's content goes here
    );
  }
}
```

By wrapping your screen's content with the `BaseLayout` widget, you ensure that the screen follows the consistent layout and styling defined in the `base_layout.dart` file and benefits from the responsive layout provided by the `ResponsiveLayout` widget.

## Interaction with Other Files

The `base_layout.dart` file interacts with several other files in the project:

- `color_palette.dart`: Imports the color constants used for styling the layout, such as the background color.
- `spacing_constants.dart`: Imports the spacing constants used for consistent padding and margins throughout the app.
- `typography_styles.dart`: Imports the typography styles used for consistent text styling across the app.
- `nav_bar.dart`: Imports the custom `NavBar` widget, which is used as the app bar in the `BaseLayout` widget.
- `responsive_layout.dart`: Imports the `ResponsiveLayout` widget, which is used to provide a responsive layout to all screens using the `BaseLayout` widget.

These files work together to create a cohesive and consistent visual design throughout the Connie AI Assistant app.

## Best Practices

When working with the `BaseLayout` widget, follow these best practices:

1. Use the `BaseLayout` widget as the top-level widget for each screen in the app to ensure consistent layout and styling.
2. Customize the `NavBar` widget as needed to include additional navigation options or modify the app bar's appearance.
3. Use the constants defined in `color_palette.dart`, `spacing_constants.dart`, and `typography_styles.dart` to maintain a consistent visual design across the app.
4. Place screen-specific content and widgets within the `child` parameter of the `BaseLayout` widget.
5. Avoid duplicating the `NavBar` or other layout components within individual screens to prevent inconsistencies and redundancy.

By following these best practices and utilizing the `BaseLayout` widget effectively, you can create a visually appealing and consistent user interface for the Connie AI Assistant app.

## Responsive Layout

The `BaseLayout` widget internally uses the `ResponsiveLayout` widget to provide a responsive layout to all screens using the base layout. This means that screens using the `BaseLayout` widget will automatically benefit from the responsive behavior without the need to explicitly wrap them with the `ResponsiveLayout` widget.

For more information on the `ResponsiveLayout` widget and how it works, refer to the `RESPONSIVE_LAYOUT.md` documentation file.

## Creating a New Page

To create a new page in the Connie AI Assistant app, follow these steps:

1. Create a new file in the `lib/ui/screens` directory with a descriptive name for the page (e.g., `new_page_screen.dart`).

2. Import the necessary dependencies, including `base_layout.dart` and `responsive_layout.dart`.

3. Define a new widget that extends `StatelessWidget` or `StatefulWidget`, depending on the page's requirements.

4. Inside the `build` method, wrap the page's content with the `BaseLayout` widget.

5. Wrap the `BaseLayout` widget with the `ResponsiveLayout` widget to ensure responsiveness.

6. Customize the page's content and widgets as needed, following the best practices and design guidelines.

7. Update the `app_router.dart` file to include a new route for the page, if necessary.

8. Create a new documentation file in the `docs/screens` directory (e.g., `NEW_PAGE_SCREEN.md`) to document the page's purpose, usage, and interactions with other files.

By following these steps, you can ensure that new pages are consistently built and integrated into the Connie AI Assistant app.