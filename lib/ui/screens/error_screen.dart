import 'package:flutter/material.dart';
import '../../services/logger_service.dart';

/// Screen that displays navigation and routing errors
class ErrorScreen extends StatelessWidget {
  final Object? error;

  const ErrorScreen({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: BackButton(
          onPressed: () {
            LoggerService.debug('Navigating back from error screen');
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Navigation Error',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (error != null)
                SelectableText(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  LoggerService.debug('Returning to home from error screen');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                },
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 