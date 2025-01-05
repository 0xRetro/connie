import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layout/color_palette.dart';
import '../layout/typography_styles.dart';
import '../layout/spacing_constants.dart';

/// A navigation bar widget that provides consistent navigation across the app
/// 
/// Usage:
/// ```dart
/// NavBar(
///   context: context,
///   title: 'Screen Title',
/// )
/// ```
/// 
/// The NavBar provides navigation to key app sections and maintains consistent styling.
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String? title;
  final List<Widget>? actions;

  const NavBar({
    super.key,
    required this.context,
    this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(
            icon: Icons.home,
            label: 'Home',
            onPressed: () => context.go('/'),
          ),
          _buildNavButton(
            icon: Icons.people,
            label: 'People',
            onPressed: () => context.go('/people'),
          ),
          _buildNavButton(
            icon: Icons.settings,
            label: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      actions: actions,
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingSmall),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: kHeadline2.copyWith(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacingMedium,
            vertical: kSpacingSmall,
          ),
        ),
      ),
    );
  }
} 