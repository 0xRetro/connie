import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/nav_bar.dart';
import '../widgets/database_schema_manager.dart';
import '../widgets/migration/migration_center.dart';
import '../layout/spacing_constants.dart';

/// Screen for managing database schema and migrations
class ContextScreen extends ConsumerWidget {
  const ContextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: NavBar(
        context: context,
        title: 'Context',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kSpacingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Schema Manager
              const Expanded(
                flex: 3,
                child: DatabaseSchemaManager(),
              ),
              const SizedBox(width: kSpacingMedium),
              
              // Right side - Migration Center
              const Expanded(
                flex: 2,
                child: MigrationCenter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 