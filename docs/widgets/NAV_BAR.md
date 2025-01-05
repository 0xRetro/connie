# NavBar Widget

The `nav_bar.dart` file contains the `NavBar` widget, which is a custom app bar used in the Connie AI Assistant app. It provides a consistent navigation bar across all screens with a title and navigation buttons.

## File Location

`lib/ui/widgets/nav_bar.dart`

## Description

The `NavBar` widget is an `AppBar` that displays the app's title and navigation buttons. It uses the `go_router` package for navigation and includes buttons for the following routes:

- Home (`/`)
- People (`/people`)
- Manage People (`/people/manage`)
- Settings (`/settings`)

The `NavBar` widget is defined as follows:

```dart
class NavBar extends AppBar {
  NavBar({
    Key? key,
    required BuildContext context,
  }) : super(
          key: key,
          backgroundColor: kPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Navigation buttons...
            ],
          ),
        );
}
```

## Usage

The `NavBar` widget is used within the `BaseLayout` widget to provide a consistent app bar across all screens. It is instantiated with the current `BuildContext` to enable navigation functionality.

```dart
class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: NavBar(context: context),
        body: Padding(
          padding: const EdgeInsets.all(kSpacingMedium),
          child: child,
        ),
      ),
    );
  }
}
```

## Interaction with Other Files

The `nav_bar.dart` file interacts with the following files and concepts:

- `go_router` package: The `NavBar` widget uses the `go_router` package for navigation between screens.
- `color_palette.dart`: Imports the color constants used for styling the app bar, such as the background color.
- `typography_styles.dart`: Imports the typography styles used for styling the navigation button text.
- `base_layout.dart`: The `NavBar` widget is used within the `BaseLayout` widget to provide a consistent app bar across all screens.

## Best Practices

When working with the `NavBar` widget, follow these best practices:

1. Use the `NavBar` widget consistently across all screens in the app to maintain a cohesive navigation experience.
2. Customize the `NavBar` widget's properties, such as the background color and button styles, to match the app's branding and design guidelines.
3. Keep the `NavBar` widget focused on navigation-related elements and avoid overloading it with unnecessary content.
4. If additional functionality is required in the app bar, consider creating separate widget files and importing them into the `nav_bar.dart` file to keep the code modular and maintainable.

By utilizing the `NavBar` widget effectively and following these best practices, you can create a consistent and user-friendly navigation experience in the Connie AI Assistant app. 