# Main Screen

The main screen is the initial screen that users see when they launch the Connie AI Assistant application. It serves as the entry point for the app and provides a welcome message to the users.

## File Location

`lib/ui/screens/main_screen.dart`

## Description

The `MainScreen` widget is a `StatelessWidget` that builds the main screen of the application. It consists of the following elements:

1. An `AppBar` with the title "Connie AI Assistant".
2. A centered `Column` widget that contains a `Text` widget displaying the welcome message.

The `MainScreen` widget is defined as follows:

```dart
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connie AI Assistant'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Connie AI Assistant!',
            ),
          ],
        ),
      ),
    );
  }
}
```

## Usage

The `MainScreen` widget is used as the initial route in the `app_router.dart` file. When the app is launched, the `MainScreen` widget is displayed as the first screen.

```dart
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    // TODO: Add more routes for other screens (e.g., chat screen, settings screen)
  ],
);
```

## Customization

You can customize the appearance and content of the main screen by modifying the `MainScreen` widget. Some possible customizations include:

- Changing the app bar title or adding additional actions.
- Modifying the welcome message text or styling.
- Adding buttons or other interactive elements to the main screen.
- Incorporating images, logos, or other visual elements.

As the project progresses, the main screen can be further enhanced to provide a more engaging and informative entry point for the Connie AI Assistant application. 