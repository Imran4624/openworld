import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
class SidePaddingTheme extends ThemeExtension<SidePaddingTheme> {
  final EdgeInsets sidePadding;
  const SidePaddingTheme({required this.sidePadding});

  @override
  SidePaddingTheme copyWith({EdgeInsets? sidePadding}) {
    return SidePaddingTheme(sidePadding: sidePadding ?? this.sidePadding);
  }

  @override
  SidePaddingTheme lerp(ThemeExtension<SidePaddingTheme>? other, double t) {
    if (other is! SidePaddingTheme) return this;
    return SidePaddingTheme(
      sidePadding: EdgeInsets.lerp(sidePadding, other.sidePadding, t) ?? sidePadding,
    );
  }
}

// Theme color collection class
class ThemeColors {
  const ThemeColors({
    required this.primary,
    required this.secondary,
    required this.iconLight,
    required this.background,
    required this.text,
    required this.textSecondary,
    required this.defaultColor,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.transparent,
    required this.emptyStateBackground,
    required this.sentMessageBackground,
    required this.surfaceContainer,
    required this.onSurfaceVariant,
    required this.outline,
  });

  final Color primary;
  final Color secondary;
  final Color iconLight;
  final Color background;
  final Color text;
  final Color textSecondary;
  final Color defaultColor;
  final Color success;
  final Color danger;
  final Color warning;
  final Color info;
  final Color transparent;
  final Color emptyStateBackground;
  final Color sentMessageBackground;
  final Color surfaceContainer;
  final Color onSurfaceVariant;
  final Color outline;
}

class AppTheme {
  static const String defaultFontFamily = 'Montserrat';
  
  static String getDefaultFontFamily() {
    if (ProjectConfig.appType == AppType.opw) {
      return 'SF Pro Text';
    }
    return defaultFontFamily;
  }

  static ThemeColors get light {
if (ProjectConfig.appType == AppType.opw) {
      return const ThemeColors(
        primary: Colors.black,
        secondary: Colors.white,
        iconLight: Colors.white,
        background: Color(0xFFF3F4F6),
        text: Colors.black87,
        textSecondary: Color(0xFF666666),
        defaultColor: Color(0xFF666666),
        success: Color(0xFF4c9a1c),
        danger: Color(0xffb93700),
        warning: Color(0xFFcd8900),
        info: Color(0xFF57a6e4),
        transparent: Colors.transparent,
        emptyStateBackground: Color(0xFFE8E9F4),
        sentMessageBackground: Color(0xFFD4F7D4),
        surfaceContainer: Color(0xFFFFFFFF),
        onSurfaceVariant: Color(0xFF666666),
        outline: Color(0xFFE0E0E0),
      );
    } else {
      return const ThemeColors(
        primary: Color.fromARGB(255, 192, 90, 7),
        secondary: Colors.white,
        iconLight: Colors.white,
        background: Color(0xFFF3F4F6),
        text: Colors.black87,
        textSecondary: Colors.black54,
        defaultColor: Color(0xFF666666),
        success: Color(0xFF4c9a1c),
        danger: Color(0xffb93700),
        warning: Color(0xFFcd8900),
        info: Color(0xFF57a6e4),
        transparent: Colors.transparent,
        emptyStateBackground: Color(0xFFE8E9F4),
        sentMessageBackground: Color(0xFFD4F7D4),
        surfaceContainer: Color(0xFFFFFFFF),
        onSurfaceVariant: Color(0xFF666666),
        outline: Color(0xFFE0E0E0),
      );
    }
  }

  static ThemeColors get dark {
  if (ProjectConfig.appType == AppType.opw) {
      return const ThemeColors(
        primary: Colors.white,
        secondary: Colors.black,
        iconLight: Colors.white,
        background: Color(0xFF2F2E2E),
        text: Colors.white70,
        textSecondary: Color(0xFFAAAAAA),
        defaultColor: Color(0xFFAAAAAA),
        success: Color(0xFF73a839),
        danger: Color(0xffb93700),
        warning: Color(0xFFcd8900),
        info: Color(0xFF57a6e4),
        transparent: Colors.transparent,
        emptyStateBackground: Color(0xFF232336),
        sentMessageBackground: Color(0xFFD4F7D4),
        surfaceContainer: Color(0xFF3C3C3C),
        onSurfaceVariant: Color(0xFFAAAAAA),
        outline: Color(0xFF555555),
      );
    } else {
      return const ThemeColors(
        primary: Color.fromARGB(255, 192, 90, 7),
        secondary: Colors.black,
        iconLight: Colors.white,
        background: Color(0xFF2F2E2E),
        text: Colors.white,
        textSecondary: Colors.white70,
        defaultColor: Color(0xFFAAAAAA),
        success: Color(0xFF73a839),
        danger: Color(0xffb93700),
        warning: Color(0xFFcd8900),
        info: Color(0xFF57a6e4),
        transparent: Colors.transparent,
        emptyStateBackground: Color(0xFF232336),
        sentMessageBackground: Color(0xFFD4F7D4),
        surfaceContainer: Color(0xFF3C3C3C),
        onSurfaceVariant: Color(0xFFAAAAAA),
        outline: Color(0xFF555555),
      );
    }
  }

  static ThemeColors getThemeColors(bool enableDarkMode) {
    return enableDarkMode ? dark : light;
  }

  static ThemeData getTheme(
    bool darkModeEnabled, {
    Color? accentColor,
    bool hasAccentColor = false,
    required PageTransitionsTheme pageTransitionsTheme,
    required ButtonStyle textButtonTheme,
    required ButtonStyle outlinedButtonTheme,
    required double deviceWidth,
  }) {
    final colors = darkModeEnabled ? dark : light;
    final base = darkModeEnabled ? ThemeData.dark() : ThemeData.light();

    final double? padding = ProjectConfig.maxContainerPaddingForWidth(deviceWidth);
    final Iterable<ThemeExtension<dynamic>> sidePaddingExtension =
      padding != null
        ? [SidePaddingTheme(sidePadding: EdgeInsets.symmetric(horizontal: padding))]
        : const [];

    if (darkModeEnabled) {
      return ThemeData(
        useMaterial3: false,
        tooltipTheme: TooltipThemeData(
          waitDuration: Duration(milliseconds: 500),
        ),
        pageTransitionsTheme: pageTransitionsTheme,
        primaryColor: light.primary,
        indicatorColor: accentColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: accentColor,
        ),
        fontFamily: getDefaultFontFamily(),
        canvasColor: colors.background,
        cardColor: colors.secondary,
        primaryColorDark: colors.background,
        textButtonTheme: TextButtonThemeData(style: textButtonTheme),
        outlinedButtonTheme:
            OutlinedButtonThemeData(style: outlinedButtonTheme),
        colorScheme: ColorScheme.dark().copyWith(
          secondary: accentColor,
          primary: accentColor,
          surface: colors.secondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colors.primary),
                foregroundColor: MaterialStateProperty.all(dark.text))),
        inputDecorationTheme: _getInputDecorationTheme(colors, true),
        textTheme: _createTextTheme(base.textTheme),
        primaryTextTheme: _createTextTheme(base.primaryTextTheme),
        bottomAppBarTheme: BottomAppBarTheme(color: colors.secondary),
        extensions: sidePaddingExtension,
      );
    } else {
      return ThemeData(
        useMaterial3: false,
        tooltipTheme: TooltipThemeData(
          waitDuration: Duration(milliseconds: 500),
        ),
        pageTransitionsTheme: pageTransitionsTheme,
        primaryColor: light.primary,
        indicatorColor: accentColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: accentColor,
        ),
        fontFamily: getDefaultFontFamily(),
        canvasColor: colors.background,
        cardColor: colors.secondary,
        primaryColorDark: hasAccentColor ? accentColor : colors.background,
        scaffoldBackgroundColor: colors.background,
        tabBarTheme: TabBarTheme(
          labelColor: hasAccentColor ? colors.text : dark.text,
          unselectedLabelColor:
              hasAccentColor ? colors.textSecondary : dark.textSecondary,
        ),
        iconTheme: IconThemeData(
          color: hasAccentColor ? null : light.primary,
        ),
        appBarTheme: AppBarTheme(
          color: colors.secondary,
          iconTheme: IconThemeData(
            color: colors.text,
          ),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: colors.text,
            fontFamily: getDefaultFontFamily(),
          ),
        ),
        textButtonTheme: TextButtonThemeData(style: textButtonTheme),
        outlinedButtonTheme:
            OutlinedButtonThemeData(style: outlinedButtonTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colors.primary),
                foregroundColor: MaterialStateProperty.all(dark.text))),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: accentColor,
          surface: colors.secondary,
        ),
        inputDecorationTheme: _getInputDecorationTheme(colors, false),
        textTheme: _createTextTheme(base.textTheme),
        primaryTextTheme: _createTextTheme(base.primaryTextTheme),
        bottomAppBarTheme: BottomAppBarTheme(color: colors.secondary),
        extensions: sidePaddingExtension,
      );
    }
  }

  static TextTheme _createTextTheme(TextTheme base) {
    final fontFamily = getDefaultFontFamily();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontFamily: fontFamily),
      displayMedium: base.displayMedium?.copyWith(fontFamily: fontFamily),
      displaySmall: base.displaySmall?.copyWith(fontFamily: fontFamily),
      headlineLarge: base.headlineLarge?.copyWith(fontFamily: fontFamily),
      headlineMedium: base.headlineMedium?.copyWith(fontFamily: fontFamily),
      headlineSmall: base.headlineSmall?.copyWith(fontFamily: fontFamily),
      titleLarge: base.titleLarge?.copyWith(fontFamily: fontFamily),
      titleMedium: base.titleMedium?.copyWith(fontFamily: fontFamily),
      titleSmall: base.titleSmall?.copyWith(fontFamily: fontFamily),
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: fontFamily),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: fontFamily),
      bodySmall: base.bodySmall?.copyWith(fontFamily: fontFamily),
      labelLarge: base.labelLarge?.copyWith(fontFamily: fontFamily),
      labelMedium: base.labelMedium?.copyWith(fontFamily: fontFamily),
      labelSmall: base.labelSmall?.copyWith(fontFamily: fontFamily),
    );
  }

  static InputDecorationTheme _getInputDecorationTheme(ThemeColors colors, bool isDark) {
    if (ProjectConfig.appType == AppType.opw) {
      return InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.danger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.danger,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontFamily: getDefaultFontFamily(),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[700],
          fontFamily: getDefaultFontFamily(),
        ),
      );
    }
    
    return const InputDecorationTheme();
  }

  static ThemeData lightTheme([Color? accentColor]) {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: accentColor ?? light.primary,
      scaffoldBackgroundColor: light.background,
      cardColor: light.secondary,
      colorScheme: ColorScheme.light(
        primary: accentColor ?? light.primary,
        secondary: accentColor ?? light.primary,
      ),
      textTheme: _createTextTheme(base.textTheme),
      primaryTextTheme: _createTextTheme(base.primaryTextTheme),
    );
  }

  static ThemeData darkTheme([Color? accentColor]) {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      primaryColor: accentColor ?? dark.primary,
      scaffoldBackgroundColor: dark.background,
      cardColor: dark.secondary,
      colorScheme: ColorScheme.dark(
        primary: accentColor ?? dark.primary,
        secondary: accentColor ?? dark.primary,
      ),
      textTheme: _createTextTheme(base.textTheme),
      primaryTextTheme: _createTextTheme(base.primaryTextTheme),
    );
  }
}
