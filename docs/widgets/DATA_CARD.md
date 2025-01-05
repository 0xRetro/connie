# DataCard Widget

The `data_card.dart` file contains the `DataCard` widget, which is a reusable widget that displays a title and a list of key-value pairs in a card format.

## File Location

`lib/ui/widgets/data_card.dart`

## Description

The `DataCard` widget is a `StatelessWidget` that displays a title and a list of key-value pairs in a card format. It uses the `ResponsiveRowColumn` widget from the `responsive_framework` package to adapt the layout based on the screen size.

The `DataCard` widget has the following properties:

- `title`: The title text to be displayed at the top of the card.
- `fields`: A list of `MapEntry` objects representing the key-value pairs to be displayed in the card.

The `DataCard` widget is defined as follows:

```dart
class DataCard extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> fields;

  const DataCard({
    super.key,
    required this.title,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            ResponsiveRowColumn(
              rowMainAxisAlignment: MainAxisAlignment.start,
              rowPadding: const EdgeInsets.symmetric(vertical: 8.0),
              columnPadding: const EdgeInsets.symmetric(vertical: 4.0),
              layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: fields.map((field) => ResponsiveRowColumnItem(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${field.key}: ',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        field.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Usage

To use the `DataCard` widget, create an instance of it and provide the required `title` and `fields` parameters:

```dart
DataCard(
  title: 'Person Details',
  fields: [
    MapEntry('Name', 'John Doe'),
    MapEntry('Age', '30'),
    MapEntry('Email', 'john.doe@example.com'),
  ],
),
```

The `DataCard` widget can be used in any screen or widget where a consistent card layout for displaying key-value pairs is needed.

## Interaction with Other Files

The `data_card.dart` file interacts with the following files and concepts:

- `responsive_framework` package: The `DataCard` widget uses the `ResponsiveRowColumn` and `ResponsiveWrapper` widgets from this package to adapt the layout based on the screen size.
- `Theme`: The `DataCard` widget uses the `Theme` of the current context to style the text.

## Best Practices

When working with the `DataCard` widget, follow these best practices:

1. Use the `DataCard` widget consistently throughout the app to maintain a cohesive design for displaying key-value pairs in a card format.
2. Provide meaningful and concise text for the `title` and `fields` parameters to effectively convey the information being displayed.
3. If additional customization is needed, consider extending the `DataCard` widget or creating a separate widget file for more complex card layouts.

By utilizing the `DataCard` widget effectively and following these best practices, you can create consistent and informative card layouts for displaying key-value pairs in the Connie AI Assistant app.