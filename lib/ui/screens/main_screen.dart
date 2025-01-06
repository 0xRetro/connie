import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
//import '../layout/base_layout.dart';
import '../widgets/header_widget.dart';
import '../widgets/error_boundary.dart';
import '../widgets/nav_bar.dart';
import '../layout/responsive_layout.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';

/// Main screen of the application
/// Displays the welcome message and primary content
///
/// Navigation:
/// - Entry points: Initial app launch, '/' route
/// - Exit points: Navigation to other screens via NavBar
///
/// Dependencies:
/// - Widgets: HeaderWidget, ErrorBoundary, NavBar
/// - Layout: BaseLayout, ResponsiveLayout
///
/// Error Handling:
/// - Uses ErrorBoundary for catching and displaying widget errors
/// - Logs errors using Logger
class MainScreen extends ConsumerWidget {
  static final _logger = Logger();
  
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.d('Building MainScreen');
    
    return Scaffold(
      appBar: NavBar(
        context: context,
        title: 'Connie',
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // TODO: Implement help action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveSpacing.getPadding(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResponsiveConstraints.constrain(
                  const HeaderWidget(
                    title: 'Welcome to Connie',
                    subtitle: 'Your AI-powered assistant',
                  ),
                ),
                const SizedBox(height: kSpacingLarge),
                // Main content with error boundary
                ResponsiveConstraints.constrain(
                  ErrorBoundary(
                    child: _buildMainContent(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Getting Started',
              style: kHeadline3,
            ),
            SizedBox(height: kSpacingMedium),
            Text(
              'Connie is your AI-powered assistant, ready to help you with your tasks.',
              style: kBodyText,
            ),
            SizedBox(height: kSpacingMedium),
            _QuickStartGuide(),
          ],
        ),
      ),
    );
  }
}

/// Quick start guide section showing key features
class _QuickStartGuide extends StatelessWidget {
  const _QuickStartGuide();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Start Guide',
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kSpacingSmall),
        _buildFeatureItem(
          icon: Icons.chat_bubble_outline,
          text: 'Start a conversation with Connie',
        ),
        _buildFeatureItem(
          icon: Icons.settings,
          text: 'Configure your preferences',
        ),
        _buildFeatureItem(
          icon: Icons.help_outline,
          text: 'Access help and documentation',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacingSmall),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: kSpacingSmall),
          Expanded(
            child: Text(text, style: kBodyText),
          ),
        ],
      ),
    );
  }
}
