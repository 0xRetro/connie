import 'package:flutter/material.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';
import '../layout/breakpoints.dart';

/// A card widget that displays structured data in a responsive layout
///
/// Features:
/// - Responsive layout that adapts to screen size
/// - Title and field display
/// - Optional action button
/// - Consistent styling and spacing
class DataCard extends StatelessWidget {
  /// Title displayed at the top of the card
  final String title;

  /// List of key-value pairs to display
  final List<MapEntry<String, String>> fields;

  /// Optional action button displayed at the bottom
  final Widget? actionButton;

  const DataCard({
    super.key,
    required this.title,
    required this.fields,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: kSpacingSmall,
        horizontal: kSpacingMedium,
      ),
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kHeadline3,
            ),
            const SizedBox(height: kSpacingSmall),
            MediaQuery.of(context).size.width < kTabletBreakpoint
              ? _buildFieldsColumn(context)
              : _buildFieldsRow(context),
            if (actionButton != null) ...[
              const SizedBox(height: kSpacingMedium),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFieldsColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((field) => _buildField(context, field)).toList(),
    );
  }

  Widget _buildFieldsRow(BuildContext context) {
    return Wrap(
      spacing: kSpacingMedium,
      runSpacing: kSpacingSmall,
      children: fields.map((field) => _buildField(context, field)).toList(),
    );
  }

  Widget _buildField(BuildContext context, MapEntry<String, String> field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacingSmall),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${field.key}: ',
            style: kBodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            field.value,
            style: kBodyText,
          ),
        ],
      ),
    );
  }
}
