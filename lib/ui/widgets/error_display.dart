import 'package:flutter/material.dart';

/// Widget for displaying error messages consistently across the app
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.onError,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Retry'),
          ),
        ],
      ],
    );
  }
} 