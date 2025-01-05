# HeaderWidget

The `header_widget.dart` file contains the `HeaderWidget` class, which is a reusable widget that displays a title and subtitle in a consistent style.

## File Location

`lib/ui/widgets/header_widget.dart`

## Description

The `HeaderWidget` is a `StatelessWidget` that displays a title and subtitle in a column layout. It uses the `Theme` of the current context to style the text.

The `HeaderWidget` has the following properties:

- `title`: The main title text to be displayed.
- `subtitle`: The subtitle text to be displayed below the title.

The `HeaderWidget` is defined as follows:

```dart
class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
```

## Usage

To use the `HeaderWidget`, simply create an instance of it and provide the required `title` and `subtitle` parameters:

```dart
HeaderWidget(
  title: 'Welcome to Connie AI Assistant',
  subtitle: 'Your personal AI companion',
),
```

The `HeaderWidget` can be used in any screen or widget where a consistent title and subtitle style is needed.

## Interaction with Other Files

The `header_widget.dart` file does not directly interact with other files, but it relies on the `Theme` of the current context to style the text. The `Theme` is typically defined in the `main.dart` file or in a separate theme file.

## Best Practices

When working with the `HeaderWidget`, follow these best practices:

1. Use the `HeaderWidget` consistently throughout the app to maintain a cohesive design for titles and subtitles.
2. Provide meaningful and concise text for the `title` and `subtitle` parameters to effectively convey the purpose of the section or screen.
3. If additional customization is needed, consider extending the `HeaderWidget` class or creating a separate widget file for more complex header layouts.

By utilizing the `HeaderWidget` effectively and following these best practices, you can create consistent and informative headers throughout the Connie AI Assistant app. 