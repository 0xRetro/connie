import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../layout/spacing_constants.dart';
import '../../layout/color_palette.dart';

/// Widget that displays the current schema version
class SchemaVersionBadge extends ConsumerWidget {
  const SchemaVersionBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get current version from provider
    const version = 1;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kSpacingMedium,
        vertical: kSpacingSmall,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schema_outlined,
            size: 16,
            color: kPrimaryColor,
          ),
          const SizedBox(width: kSpacingSmall),
          Text(
            'v$version',
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 