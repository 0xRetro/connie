# App Router

The app router is responsible for managing the navigation flow between different screens in the application. It uses the `go_router` library to define routes and their corresponding screen widgets.

## What is go_router?

`go_router` is a declarative routing package for Flutter that simplifies the process of defining routes and navigating between screens. It provides a simple and intuitive way to define routes using a tree-like structure, where each route is associated with a specific screen widget.

Some key features of `go_router` include:

- Declarative route definitions
- Typed route parameters
- Nested navigation
- Automatic deep linking
- Support for custom transitions and animations

## Routes

- `/`: The main screen route, which displays the `MainScreen` widget

## How go_router is used in the Connie AI Assistant project

In the Connie AI Assistant project, we use `go_router` to define and manage the application's routes. The `app_router.dart` file contains the `GoRouter` instance that sets up the navigation for the entire application.

Here's how we define the routes in `app_router.dart`:

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

In this code:

1. We create a `GoRouter` instance called `appRouter`.

2. We define the available routes using the `routes` parameter, which takes a list of `GoRoute` objects.

3. Each `GoRoute` object represents a specific route and contains a `path` (the URL path) and a `builder` function that returns the corresponding screen widget.

4. We have a single route defined for the main screen ('/'), which displays the `MainScreen` widget.

5. The TODO comment indicates that we will add more routes for other screens (e.g., chat screen, settings screen) as the project progresses.

By defining the routes in this way, we can easily navigate between screens using the `GoRouter` instance.

## Usage

To navigate to a specific route, you can use the `go` method provided by the `GoRouter` instance. For example:

```dart
GoRouter.of(context).go('/route-name');
```

For example, to navigate to the chat screen (assuming we have defined a route for it), we would use:

```dart
GoRouter.of(context).go('/chat');
```

## Benefits of using go_router

Using `go_router` in the Connie AI Assistant project provides several benefits:

- It allows us to define routes in a declarative and centralized manner, making it easy to understand and maintain the application's navigation structure.
- It provides type safety for route parameters, reducing the chances of runtime errors related to navigation.
- It supports nested navigation, allowing us to create complex navigation hierarchies with ease.
- It generates automatic deep links for each route, enabling deep linking capabilities in the application.
- It offers customization options for transitions and animations, allowing us to create visually appealing navigation experiences.

By leveraging `go_router`, we can create a robust and scalable navigation system for the Connie AI Assistant project, making it easier to add new screens and manage the flow between them.

## File Location

`lib/navigation/app_router.dart` 