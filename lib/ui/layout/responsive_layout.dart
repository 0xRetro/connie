import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Manages responsive layout and adaptive design for the application
class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      child,
      defaultScale: true, // Enable scaling for responsive design
      minWidth: 320,
      defaultName: MOBILE,
      breakpoints: [
        const ResponsiveBreakpoint.resize(ResponsiveBreakpoints.mobile, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(ResponsiveBreakpoints.tablet, name: TABLET),
        const ResponsiveBreakpoint.resize(ResponsiveBreakpoints.desktop, name: DESKTOP),
      ],
      breakpointsLandscape: [
        const ResponsiveBreakpoint.resize(ResponsiveBreakpoints.mobile, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(ResponsiveBreakpoints.tablet, name: TABLET),
        const ResponsiveBreakpoint.resize(ResponsiveBreakpoints.desktop, name: DESKTOP),
      ],
      background: Container(
        color: Theme.of(context).colorScheme.surface, // Use surface color for consistency with the theme
      ),
    );
  }
}

/// Provides responsive spacing utilities for padding and margins.
class ResponsiveSpacing {
  static double get xs => 4;
  static double get sm => 8;
  static double get md => 16;
  static double get lg => 24;
  static double get xl => 32;
  static double get xxl => 48;

  /// Gets responsive padding based on screen size
  static EdgeInsets getPadding(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    if (responsive.isLargerThan(TABLET)) {
      return EdgeInsets.all(lg);
    } else if (responsive.isLargerThan(MOBILE)) {
      return EdgeInsets.all(md);
    }
    return EdgeInsets.all(sm);
  }

  /// Gets responsive margin based on screen size
  static EdgeInsets getMargin(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    if (responsive.isLargerThan(TABLET)) {
      return EdgeInsets.all(md);
    } else if (responsive.isLargerThan(MOBILE)) {
      return EdgeInsets.all(sm);
    }
    return EdgeInsets.all(xs);
  }
}

/// Provides responsive layout constraints for max width and constrained boxes.
class ResponsiveConstraints {
  static double get maxWidthMobile => 600;
  static double get maxWidthTablet => 1000;
  static double get maxWidthDesktop => 1200;

  /// Gets max width constraint based on screen size
  static double getMaxWidth(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    if (responsive.isLargerThan(TABLET)) {
      return maxWidthDesktop;
    } else if (responsive.isLargerThan(MOBILE)) {
      return maxWidthTablet;
    }
    return maxWidthMobile;
  }

  /// Creates a constrained box based on screen size
  static Widget constrain(Widget child) {
    return Builder(
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: getMaxWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Defines responsive breakpoints for the application
class ResponsiveBreakpoints {
  static const double mobile = 350;
  static const double tablet = 600;
  static const double desktop = 1000;
}