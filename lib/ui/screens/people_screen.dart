import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/header_widget.dart';
import '../widgets/nav_bar.dart';
import '../widgets/error_boundary.dart';
import '../widgets/data_card.dart';
import '../widgets/person_form_dialog.dart';
import '../layout/responsive_layout.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';
import '../../providers/people_provider.dart';
import '../../database/database.dart' show Person;

/// Screen that displays and manages the list of people in the system
///
/// Navigation:
/// - Entry points: '/people' route, NavBar people button
/// - Exit points: NavBar navigation, person detail view
///
/// Dependencies:
/// - Providers: peopleNotifierProvider
/// - Widgets: HeaderWidget, NavBar, ErrorBoundary, DataCard, PersonFormDialog
/// - Layout: BaseLayout, ResponsiveLayout
///
/// Error Handling:
/// - Uses ErrorBoundary for catching and displaying widget errors
/// - Handles async data loading states
class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => PersonFormDialog(
        onSubmit: (name, isSuperUser) async {
          await ref.read(peopleNotifierProvider.notifier)
            .createPerson(name, isSuperUser: isSuperUser);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Person person) {
    showDialog(
      context: context,
      builder: (context) => PersonFormDialog(
        initialName: person.name,
        initialIsSuperUser: person.isSuperUser,
        onSubmit: (name, isSuperUser) async {
          await ref.read(peopleNotifierProvider.notifier)
            .updatePerson(person.copyWith(
              name: name,
              isSuperUser: isSuperUser,
              updatedAt: DateTime.now(),
            ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: NavBar(
        context: context,
        title: 'People',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showCreateDialog(context, ref),
            tooltip: 'Add Person',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter action
            },
            tooltip: 'Filter List',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveSpacing.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ResponsiveConstraints.constrain(
                const HeaderWidget(
                  title: 'People',
                  subtitle: 'View and manage people in the system',
                ),
              ),
              const SizedBox(height: kSpacingLarge),
              Expanded(
                child: ResponsiveConstraints.constrain(
                  ErrorBoundary(
                    child: _buildContent(context, ref),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        tooltip: 'Add Person',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final peopleAsync = ref.watch(peopleNotifierProvider);

    return peopleAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading people: $error',
          style: kBodyText.copyWith(color: Colors.red),
        ),
      ),
      data: (people) => people.isEmpty
        ? const Center(
            child: Text(
              'No people found',
              style: kBodyText,
            ),
          )
        : ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];
              return DataCard(
                title: person.name,
                fields: [
                  MapEntry('ID', person.id.toString()),
                  MapEntry('Super User', person.isSuperUser ? 'Yes' : 'No'),
                  MapEntry('Created', person.createdAt.toLocal().toString()),
                  MapEntry('Updated', person.updatedAt.toLocal().toString()),
                ],
                actionButton: TextButton.icon(
                  onPressed: () => _showEditDialog(context, ref, person),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              );
            },
          ),
    );
  }
} 