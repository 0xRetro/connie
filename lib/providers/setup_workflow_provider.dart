import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/setup_workflow_service.dart';

/// Provider for managing setup workflow state
final setupWorkflowStateProvider = FutureProvider.autoDispose<void>((ref) async {
  final setupService = ref.watch(setupWorkflowProvider);
  await setupService.validateSetup();
}); 