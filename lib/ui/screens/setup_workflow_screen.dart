import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../layout/base_layout.dart';
import '../widgets/header_widget.dart';
import '../widgets/error_display.dart';
import '../../providers/first_run_provider.dart';
import '../../providers/setup_workflow_provider.dart';
import '../../services/setup_workflow_service.dart';
import '../../services/logger_service.dart';

/// Screen that handles first-time setup workflow for the application
///
/// Navigation:
/// - Entry points: Initial app launch when isFirstRun is true
/// - Exit points: '/' route after successful setup
///
/// Dependencies:
/// - Providers: firstRunStateNotifierProvider, setupWorkflowProvider
/// - Services: SetupWorkflowService, LoggerService
/// - Widgets: HeaderWidget, SetupActionButton, ErrorDisplay
///
/// Error Handling:
/// - Displays error message using ErrorDisplay widget
/// - Logs errors with stack trace
/// - Provides retry functionality
class SetupWorkflowScreen extends ConsumerWidget {
  const SetupWorkflowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScreenLayout(
      title: 'Setup',
      state: ref.watch(setupWorkflowStateProvider),
      onData: (_, __) => _buildContent(context, ref),
      onRetry: () => ref.refresh(setupWorkflowStateProvider),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const HeaderWidget(
          title: 'Welcome to Connie',
          subtitle: 'Let\'s get you set up',
        ),
        const SizedBox(height: 32),
        SetupActionButton(
          onSetupComplete: () => _handleSetupComplete(context, ref),
        ),
      ],
    );
  }

  Future<void> _handleSetupComplete(BuildContext context, WidgetRef ref) async {
    try {
      // Run setup workflow
      final setupService = ref.read(setupWorkflowProvider);
      await setupService.handleSetupIfNeeded(true);
      
      // Reset first run state
      await ref.read(firstRunStateNotifierProvider.notifier).resetFirstRun();
      
      if (context.mounted) {
        context.go('/');
      }
    } catch (e, stack) {
      LoggerService.error(
        'Setup completion failed',
        error: e,
        stackTrace: stack,
      );
      if (context.mounted) {
        _showError(context, 'Setup failed. Please try again.');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ErrorDisplay(message: message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Button widget for triggering setup completion
class SetupActionButton extends StatelessWidget {
  final VoidCallback onSetupComplete;

  const SetupActionButton({
    super.key,
    required this.onSetupComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSetupComplete,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
      child: const Text('Complete Setup'),
    );
  }
} 