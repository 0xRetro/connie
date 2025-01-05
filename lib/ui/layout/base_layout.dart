import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart' show ResponsiveWrapper, TABLET;
import '../widgets/error_boundary.dart';
import 'responsive_layout.dart';
import 'spacing_constants.dart';
import 'typography_styles.dart';

/// Base layout widget that provides consistent structure for screens
class BaseLayout extends ConsumerWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final bool constrainWidth;
  final EdgeInsets? padding;

  const BaseLayout({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = true,
    this.constrainWidth = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = ResponsiveWrapper.of(context);
    final isDesktop = responsive.isLargerThan(TABLET);
    
    Widget content = Padding(
      padding: padding ?? ResponsiveSpacing.getPadding(context),
      child: child,
    );

    if (constrainWidth) {
      content = ResponsiveConstraints.constrain(content);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
      body: SafeArea(
        child: content,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar != null
        ? SafeArea(child: bottomNavigationBar!)
        : null,
      drawer: isDesktop ? null : _buildDrawer(context),
    );
  }

  Widget? _buildDrawer(BuildContext context) {
    // Implement drawer if needed
    return null;
  }
}

/// Screen layout with error handling and loading states
class BaseScreenLayout extends ConsumerWidget {
  final String title;
  final AsyncValue<dynamic> state;
  final Widget Function(BuildContext, dynamic) onData;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final bool constrainWidth;
  final EdgeInsets? padding;
  final VoidCallback? onRetry;

  const BaseScreenLayout({
    super.key,
    required this.title,
    required this.state,
    required this.onData,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = true,
    this.constrainWidth = true,
    this.padding,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseLayout(
      title: title,
      actions: actions,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      showBackButton: showBackButton,
      constrainWidth: constrainWidth,
      padding: padding,
      child: state.when(
        data: (data) => ErrorBoundary(
          onRetry: onRetry,
          child: onData(context, data),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
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
                        text: error.toString(),
                        style: kBodyText.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: kSpacingSmall),
                  ElevatedButton.icon(
                    onPressed: state.isRefreshing ? null : onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
} 