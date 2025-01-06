import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../layout/spacing_constants.dart';
import '../../layout/typography_styles.dart';

/// Widget that displays migration history
class MigrationHistory extends ConsumerWidget {
  const MigrationHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get migration history from provider
    final migrations = <Map<String, dynamic>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Migration History', style: kHeadline3),
        const SizedBox(height: kSpacingSmall),
        
        if (migrations.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No migrations yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: migrations.length,
              itemBuilder: (context, index) {
                final migration = migrations[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('v${migration['version']}'),
                    ),
                    title: Text(migration['description'] as String),
                    subtitle: Text(
                      'Applied on ${migration['appliedAt']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        // TODO: Show migration details dialog
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
} 