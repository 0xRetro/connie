import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../layout/spacing_constants.dart';
import '../../layout/typography_styles.dart';
import 'pending_changes.dart';
import 'migration_history.dart';
import 'schema_version_badge.dart';

/// Widget that displays and manages database migrations
class MigrationCenter extends ConsumerWidget {
  const MigrationCenter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Migration Center', style: kHeadline3),
                const SchemaVersionBadge(),
              ],
            ),
            const SizedBox(height: kSpacingMedium),
            
            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Pending Changes
                  const Expanded(
                    flex: 2,
                    child: PendingChanges(),
                  ),
                  const SizedBox(width: kSpacingMedium),
                  
                  // Right side - Migration History
                  const Expanded(
                    flex: 3,
                    child: MigrationHistory(),
                  ),
                ],
              ),
            ),
            
            // Actions
            const Divider(height: kSpacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement rollback functionality
                  },
                  child: const Text('Rollback Last Migration'),
                ),
                const SizedBox(width: kSpacingMedium),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement apply migrations
                  },
                  child: const Text('Apply Migrations'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 