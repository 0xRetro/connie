import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../layout/spacing_constants.dart';
import '../../layout/typography_styles.dart';

/// Widget that displays pending schema changes
class PendingChanges extends ConsumerWidget {
  const PendingChanges({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get pending changes from provider
    final pendingChanges = <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pending Changes', style: kHeadline3),
        const SizedBox(height: kSpacingSmall),
        
        if (pendingChanges.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No pending changes',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: pendingChanges.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final change = pendingChanges[index];
                return ListTile(
                  leading: const Icon(Icons.change_circle_outlined),
                  title: Text(change),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      // TODO: Implement remove pending change
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
} 