import 'package:flutter/material.dart';

/// Centralised, responsive dimension values.
/// This plays the same role as values/sizes.xml (and values-sw600dp/sizes.xml)
/// on native Android: no widget hardcodes a size; every widget reads its
/// sizes from here, and values scale up automatically on tablets
/// (shortestSide >= 600dp, matching Android's sw600dp qualifier).
class AppDimensions {
  final bool isTablet;

  AppDimensions._(this.isTablet);

  factory AppDimensions.of(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return AppDimensions._(shortestSide >= 600);
  }

  // App bar
  double get appBarFontSize => isTablet ? 26 : 20;

  // "Taka: xxx" header
  double get amountLabelFontSize => isTablet ? 22 : 16;
  double get amountValueFontSize => isTablet ? 34 : 24;
  double get headerVerticalPadding => isTablet ? 24 : 12;

  // Change table
  double get tableFontSize => isTablet ? 22 : 15;
  double get tableRowSpacing => isTablet ? 10 : 4;
  double get tableColumnSpacing => isTablet ? 32 : 12;

  // Keypad
  double get keypadButtonFontSize => isTablet ? 30 : 20;
  double get keypadButtonSpacing => isTablet ? 12 : 6;
  double get keypadButtonHeight => isTablet ? 76 : 52;
  double get keypadButtonRadius => isTablet ? 12 : 8;

  // Screen
  double get screenPadding => isTablet ? 24 : 12;
  double get sectionSpacing => isTablet ? 24 : 12;
}
