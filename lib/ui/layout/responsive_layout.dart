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
      defaultScale: true,
      minWidth: 320,
      defaultName: MOBILE,
      breakpoints: [
        const ResponsiveBreakpoint.resize(350, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(600, name: TABLET),
        const ResponsiveBreakpoint.resize(800, name: TABLET),
        const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
      ],
      breakpointsLandscape: [
        const ResponsiveBreakpoint.resize(560, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(800, name: TABLET),
        const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
      ],
      background: Container(
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}

/// Provides responsive spacing utilities
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

/// Provides responsive layout constraints
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
