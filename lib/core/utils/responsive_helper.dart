import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

enum DeviceType { mobile, tablet, web }

class ResponsiveHelper {
  ResponsiveHelper._();

  static DeviceType getType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppDimensions.mobileMax) return DeviceType.mobile;
    if (width < AppDimensions.tabletMax) return DeviceType.tablet;
    return DeviceType.web;
  }

  static bool isMobile(BuildContext context) => getType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) => getType(context) == DeviceType.tablet;
  static bool isWeb(BuildContext context) => getType(context) == DeviceType.web;

  /// Returns value based on device type
  static T value<T>(BuildContext context, {required T mobile, required T tablet, required T web}) {
    switch (getType(context)) {
      case DeviceType.mobile: return mobile;
      case DeviceType.tablet: return tablet;
      case DeviceType.web:    return web;
    }
  }

  /// Responsive horizontal padding
  static double horizontalPadding(BuildContext context) =>
      value(context, mobile: 16.0, tablet: 32.0, web: 64.0);

  /// Max content width (centered on web)
  static double maxContentWidth(BuildContext context) =>
      value(context, mobile: double.infinity, tablet: 720.0, web: 1100.0);
}


/// Wrap any screen with this to get responsive layout switching
class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.web,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget web;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppDimensions.mobileMax) return mobile;
        if (constraints.maxWidth < AppDimensions.tabletMax) return tablet;
        return web;
      },
    );
  }
}