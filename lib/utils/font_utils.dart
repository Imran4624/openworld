import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_boilerplate/data/models/event_theme_model.dart';

enum TextFieldType { name, description, venue }

/// Utility class for handling Google Fonts in the application.
///
/// This utility provides a centralized way to apply Google Fonts based on
/// theme font family names, with fallback support for local fonts.
class FontUtils {
  /// Returns a TextStyle with the appropriate Google Font based on the font family name.
  ///
  /// [fontFamily] - The name of the font family (e.g., 'Playfair Display', 'Roboto')
  /// [baseStyle] - The base TextStyle to apply font styling to
  /// [theme] - Optional EventTheme to get font weights for specific text types
  /// [textType] - Type of text (name, description, venue) to apply appropriate font weight
  ///
  /// Supports all event theme fonts:
  /// - Outfit
  /// - Playfair Display
  /// - Quicksand
  /// - Shrikhand
  /// - Roboto
  /// - Montserrat
  /// - Lato
  /// - Open Sans
  ///
  /// Falls back to local fonts if the font family is not recognized.
  static TextStyle getTextStyleWithFont({
    required String? fontFamily,
    required TextStyle baseStyle,
    EventTheme? theme,
    TextFieldType? textType,
  }) {
    if (fontFamily == null || fontFamily.isEmpty) {
      return baseStyle;
    }

    FontWeight? fontWeight = baseStyle.fontWeight;
    if (theme != null && textType != null) {
      switch (textType) {
        case TextFieldType.name:
          fontWeight = theme.nameFontWeight;
          break;
        case TextFieldType.description:
          fontWeight = theme.descriptionFontWeight;
          break;
        case TextFieldType.venue:
          fontWeight = theme.venueFontWeight;
          break;
      }
    }

    switch (fontFamily) {
      case 'Outfit':
        return GoogleFonts.outfit(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Playfair Display':
        return GoogleFonts.playfairDisplay(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Quicksand':
        return GoogleFonts.quicksand(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Shrikhand':
        return GoogleFonts.shrikhand(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Roboto':
        return GoogleFonts.roboto(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Montserrat':
        return GoogleFonts.montserrat(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Lato':
        return GoogleFonts.lato(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      case 'Open Sans':
        return GoogleFonts.openSans(
          fontSize: baseStyle.fontSize,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          color: baseStyle.color,
          shadows: baseStyle.shadows,
          height: baseStyle.height,
          letterSpacing: baseStyle.letterSpacing,
          wordSpacing: baseStyle.wordSpacing,
          decoration: baseStyle.decoration,
          decorationColor: baseStyle.decorationColor,
          decorationStyle: baseStyle.decorationStyle,
          decorationThickness: baseStyle.decorationThickness,
          background: baseStyle.background,
          foreground: baseStyle.foreground,
        );
      default:
        // Fallback to fontFamily property for local fonts
        return baseStyle.copyWith(
          fontFamily: fontFamily,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
        );
    }
  }
}
