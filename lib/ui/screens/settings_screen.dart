import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/nav_bar.dart';
import '../widgets/error_boundary.dart';
import '../widgets/system_info_card.dart';
import '../widgets/ollama_settings_card.dart';
import '../layout/responsive_layout.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';

/// Settings screen that provides application configuration options
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: NavBar(
        context: context,
        title: 'Settings',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveSpacing.getPadding(context),
          child: ErrorBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: kHeadline1,
                ),
                const SizedBox(height: kSpacingMedium),
                Text(
                  'Configure application preferences and view system information',
                  style: kBodyText,
                ),
                const SizedBox(height: kSpacingLarge),
                const OllamaSettingsCard(),
                const SizedBox(height: kSpacingMedium),
                const SystemInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 