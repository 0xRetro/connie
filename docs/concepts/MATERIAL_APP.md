# MaterialApp

The `MaterialApp` widget is the root of a Flutter application that uses Material Design. It provides a simple way to configure and set up the app's visual design, navigation, and other top-level properties.

## MaterialApp.router constructor

The `MaterialApp.router` constructor is used when the app needs to handle navigation using a `GoRouter` instance. It provides a declarative way to define the app's navigation and routing logic.

## The `builder` property

The `builder` property of the `MaterialApp.router` widget is a callback function that is used to wrap the app's widget tree with additional widgets or perform any necessary setup before the app is built.

In the Connie AI Assistant project, the `builder` property is used to wrap the app with the `ResponsiveLayout` widget, which makes the app responsive and adaptable to different screen sizes and orientations.

Here's an example of how the `builder` property is used in the `main.dart` file:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Connie AI Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      builder: (context, child) => ResponsiveLayout(child: child!),
    );
  }
}
```

In this example, the `builder` property takes a function that receives the `context` and the `child` widget as arguments. The `child` widget represents the app's widget tree that is built by the `MaterialApp.router` widget.

The `ResponsiveLayout` widget is used to wrap the `child` widget, ensuring that the entire app is responsive and adapts to different screen sizes.

By utilizing the `builder` property and the `ResponsiveLayout` widget, the Connie AI Assistant app becomes responsive and provides a consistent user experience across various devices.

## Usage

To use the `MaterialApp.router` widget in your Flutter app, you need to provide the required parameters, such as `routerConfig`, `title`, and `theme`.

Here's an example of how the `MaterialApp.router` widget is used in the `main.dart` file of the Connie AI Assistant project:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Connie AI Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
```

In this example:

- The `title` parameter sets the title of the app, which is displayed in the app's task switcher and other relevant places.
- The `theme` parameter sets the app's visual theme using a `ThemeData` object. In this case, the color scheme is generated from a seed color (deep purple), and Material Design 3 is enabled.
- The `routerConfig` parameter specifies the `GoRouter` instance that defines the app's navigation and routing logic. The `appRouter` instance is defined in a separate file (`app_router.dart`) and imported into the `main.dart` file.

By configuring the `MaterialApp.router` widget with the appropriate parameters, you can set up the app's visual design, navigation, and other top-level properties in a declarative and centralized manner.

## Benefits of using MaterialApp.router

Using the `MaterialApp.router` widget in your Flutter app provides several benefits:

- It allows you to define the app's navigation and routing logic using a declarative syntax with the `GoRouter` package.
- It provides a consistent Material Design look and feel across the app, with customizable themes and styles.
- It handles the app's top-level configuration, such as the app title, theme, and other global properties, in a centralized location.
- It integrates seamlessly with other Material Design widgets and components, ensuring a cohesive and visually appealing user interface.

By leveraging the `MaterialApp.router` widget and the `GoRouter` package, you can create a well-structured and maintainable Flutter app with efficient navigation and a polished Material Design aesthetic. 