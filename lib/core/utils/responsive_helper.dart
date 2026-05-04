import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

enum DeviceType {
  mobile,
  tablet,
  large,
}

class ResponsiveHelper {
  ResponsiveHelper._();

  // =========================
  // Screen size
  // =========================

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // =========================
  // Device type
  // =========================

  static DeviceType getDeviceType(BuildContext context) {
    final width = screenWidth(context);

    if (width < AppDimensions.mobileMax) {
      return DeviceType.mobile;
    }

    if (width < AppDimensions.tabletMax) {
      return DeviceType.tablet;
    }

    return DeviceType.large;
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isLarge(BuildContext context) {
    return getDeviceType(context) == DeviceType.large;
  }

  // =========================
  // Responsive value selector
  // =========================

  static T value<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T large,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.large:
        return large;
    }
  }

  // =========================
  // Percentage sizes
  // =========================

  static double widthPercent(BuildContext context, double percent) {
    return screenWidth(context) * percent;
  }

  static double heightPercent(BuildContext context, double percent) {
    return screenHeight(context) * percent;
  }

  // =========================
  // Common layout values
  // =========================

  static double horizontalPadding(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.pageHorizontalPaddingMobile,
      tablet: AppDimensions.pageHorizontalPaddingTablet,
      large: AppDimensions.pageHorizontalPaddingLarge,
    );
  }

  static double maxContentWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: AppDimensions.maxContentWidthTablet,
      large: AppDimensions.maxContentWidthLarge,
    );
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding(context),
      vertical: AppDimensions.md,
    );
  }

  // =========================
  // Text sizes
  // =========================

  static double titleSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.titleMobile,
      tablet: AppDimensions.titleTablet,
      large: AppDimensions.titleLarge,
    );
  }

  static double pageTitleSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.pageTitleMobile,
      tablet: AppDimensions.pageTitleTablet,
      large: AppDimensions.pageTitleLarge,
    );
  }

  static double sectionTitleSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.sectionTitleMobile,
      tablet: AppDimensions.sectionTitleTablet,
      large: AppDimensions.sectionTitleLarge,
    );
  }

  static double bodyTextSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.bodyMobile,
      tablet: AppDimensions.bodyTablet,
      large: AppDimensions.bodyLarge,
    );
  }

  static double hintTextSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.hintMobile,
      tablet: AppDimensions.hintTablet,
      large: AppDimensions.hintLarge,
    );
  }

  // =========================
  // QR / Scanner sizes
  // =========================

  static double qrSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.qrSizeMobile,
      tablet: AppDimensions.qrSizeTablet,
      large: AppDimensions.qrSizeLarge,
    );
  }

  // =========================
  // Buttons
  // =========================

  static double buttonWidth(BuildContext context) {
    return value(
      context,
      mobile: widthPercent(context, 0.75),
      tablet: 420.0,
      large: 480.0,
    );
  }

  static double fullButtonWidth(BuildContext context) {
    return value(
      context,
      mobile: widthPercent(context, 0.9),
      tablet: 500.0,
      large: 560.0,
    );
  }

  // =========================
  // Bottom nav helpers
  // =========================

  static bool showBottomNavLabels(BuildContext context) {
    return screenWidth(context) >= AppDimensions.minLabelWidth;
  }

  static double bottomNavIconSize(BuildContext context) {
    return value(
      context,
      mobile: AppDimensions.iconMd,
      tablet: AppDimensions.iconLg,
      large: AppDimensions.iconLg,
    );
  }
}

// =======================================================
// Widget-level responsive switcher
// =======================================================

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.large,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget large;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppDimensions.mobileMax) {
          return mobile;
        }

        if (constraints.maxWidth < AppDimensions.tabletMax) {
          return tablet;
        }

        return large;
      },
    );
  }
}