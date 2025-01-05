import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../layout/typography_styles.dart';
import '../layout/spacing_constants.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final VoidCallback? onRetry;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.onRetry,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  static final _logger = Logger();
  Object? _error;
  StackTrace? _stackTrace;
  FlutterExceptionHandler? _originalOnError;

  @override
  void initState() {
    super.initState();
    _error = null;
    _stackTrace = null;
    _originalOnError = FlutterError.onError;
    FlutterError.onError = _handleError;
  }

  @override
  void dispose() {
    FlutterError.onError = _originalOnError;
    super.dispose();
  }

  void _handleError(FlutterErrorDetails details) {
    _logger.e(
      'Error caught by error boundary',
      error: details.exception,
      stackTrace: details.stack,
    );
    
    if (mounted) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(kSpacingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: kSpacingMedium),
              SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Error: ',
                      style: kBodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: _error.toString(),
                      style: kBodyText.copyWith(color: Colors.red),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.onRetry != null) ...[
                const SizedBox(height: kSpacingSmall),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _error = null;
                      _stackTrace = null;
                    });
                    widget.onRetry?.call();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
} 