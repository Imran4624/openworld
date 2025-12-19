// Package imports:
import 'package:flutter/material.dart';

class EventTheme {
  final String id;
  final String name;
  final String fontFamily;

  final String backgroundColorHex;
  final String detailBackgroundColorHex;
  final String onDetailBackgroundColorHex;
  final String accentColorHex;
  final String onAccentColorHex;

  final FontWeight nameFontWeight;
  final FontWeight descriptionFontWeight;
  final FontWeight venueFontWeight;

  const EventTheme({
    required this.id,
    required this.name,
    required this.fontFamily,
    required this.backgroundColorHex,
    required this.detailBackgroundColorHex,
    required this.onDetailBackgroundColorHex,
    required this.accentColorHex,
    required this.onAccentColorHex,
    this.nameFontWeight = FontWeight.w600,
    this.descriptionFontWeight = FontWeight.w400,
    this.venueFontWeight = FontWeight.w500,
  });

  Color get backgroundColor => _colorFromHex(backgroundColorHex);
  Color get detailBackgroundColor => _colorFromHex(detailBackgroundColorHex);
  Color get onDetailBackgroundColor =>
      _colorFromHex(onDetailBackgroundColorHex);
  Color get accentColor => _colorFromHex(accentColorHex);
  Color get onAccentColor => _colorFromHex(onAccentColorHex);

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String colorToHex(Color color, {bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${(color.a * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.r * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.g * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.b * 255).round().toRadixString(16).padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fontFamily': fontFamily,
        'backgroundColorHex': backgroundColorHex,
        'detailBackgroundColorHex': detailBackgroundColorHex,
        'onDetailBackgroundColorHex': onDetailBackgroundColorHex,
        'accentColorHex': accentColorHex,
        'onAccentColorHex': onAccentColorHex,
        'nameFontWeight': nameFontWeight.index,
        'descriptionFontWeight': descriptionFontWeight.index,
        'venueFontWeight': venueFontWeight.index,
      };

  factory EventTheme.fromJson(Map<String, dynamic> json) {
    return EventTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      fontFamily: json['fontFamily'] as String,
      backgroundColorHex: json['backgroundColorHex'] as String,
      detailBackgroundColorHex: json['detailBackgroundColorHex'] as String,
      onDetailBackgroundColorHex: json['onDetailBackgroundColorHex'] as String,
      accentColorHex: json['accentColorHex'] as String,
      onAccentColorHex: json['onAccentColorHex'] as String,
      nameFontWeight: json['nameFontWeight'] != null
          ? FontWeight.values[json['nameFontWeight'] as int]
          : FontWeight.w600,
      descriptionFontWeight: json['descriptionFontWeight'] != null
          ? FontWeight.values[json['descriptionFontWeight'] as int]
          : FontWeight.w400,
      venueFontWeight: json['venueFontWeight'] != null
          ? FontWeight.values[json['venueFontWeight'] as int]
          : FontWeight.w500,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTheme &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          fontFamily == other.fontFamily &&
          backgroundColorHex == other.backgroundColorHex &&
          detailBackgroundColorHex == other.detailBackgroundColorHex &&
          onDetailBackgroundColorHex == other.onDetailBackgroundColorHex &&
          accentColorHex == other.accentColorHex &&
          onAccentColorHex == other.onAccentColorHex &&
          nameFontWeight == other.nameFontWeight &&
          descriptionFontWeight == other.descriptionFontWeight &&
          venueFontWeight == other.venueFontWeight;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      fontFamily.hashCode ^
      backgroundColorHex.hashCode ^
      detailBackgroundColorHex.hashCode ^
      onDetailBackgroundColorHex.hashCode ^
      accentColorHex.hashCode ^
      onAccentColorHex.hashCode ^
      nameFontWeight.hashCode ^
      descriptionFontWeight.hashCode ^
      venueFontWeight.hashCode;

  @override
  String toString() =>
      'EventTheme{id: $id, name: $name, fontFamily: $fontFamily, '
      'background: $backgroundColorHex, detailBackground: $detailBackgroundColorHex, '
      'onDetailBackground: $onDetailBackgroundColorHex, accent: $accentColorHex, '
      'onAccent: $onAccentColorHex, nameFontWeight: $nameFontWeight, '
      'descriptionFontWeight: $descriptionFontWeight, venueFontWeight: $venueFontWeight}';

  EventTheme copyWith({
    String? id,
    String? name,
    String? fontFamily,
    String? backgroundColorHex,
    String? detailBackgroundColorHex,
    String? onDetailBackgroundColorHex,
    String? accentColorHex,
    String? onAccentColorHex,
    FontWeight? nameFontWeight,
    FontWeight? descriptionFontWeight,
    FontWeight? venueFontWeight,
  }) {
    return EventTheme(
      id: id ?? this.id,
      name: name ?? this.name,
      fontFamily: fontFamily ?? this.fontFamily,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
      detailBackgroundColorHex:
          detailBackgroundColorHex ?? this.detailBackgroundColorHex,
      onDetailBackgroundColorHex:
          onDetailBackgroundColorHex ?? this.onDetailBackgroundColorHex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      onAccentColorHex: onAccentColorHex ?? this.onAccentColorHex,
      nameFontWeight: nameFontWeight ?? this.nameFontWeight,
      descriptionFontWeight:
          descriptionFontWeight ?? this.descriptionFontWeight,
      venueFontWeight: venueFontWeight ?? this.venueFontWeight,
    );
  }
}

class EventThemes {
  static const List<EventTheme> predefinedThemes = [
    // Theme 1: Outfit
    EventTheme(
      id: 'outfit',
      name: 'Outfit',
      fontFamily: 'Outfit',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#F6F9FC',
      onDetailBackgroundColorHex: '#10243F',
      accentColorHex: '#2218E2',
      onAccentColorHex: '#FFFFFF',
      nameFontWeight: FontWeight.w700,
      descriptionFontWeight: FontWeight.w400,
      venueFontWeight: FontWeight.w600,
    ),
    // Theme 2: Shrikhand
      EventTheme(
      id: 'shrikhand',
      name: 'Shrikhand',
      fontFamily: 'Shrikhand',
      backgroundColorHex: '#FFFCEE',
      detailBackgroundColorHex: '#DED4A1',
      onDetailBackgroundColorHex: '#362C28',
      accentColorHex: '#A0467C',
      onAccentColorHex: '#FFFFFF',
      nameFontWeight: FontWeight.w600,
      descriptionFontWeight: FontWeight.w200,
      venueFontWeight: FontWeight.w400,
    ),
    
    // Theme 3: Quicksand
    EventTheme(
      id: 'quicksand',
      name: 'Quicksand',
      fontFamily: 'Quicksand',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#1C4140',
      onDetailBackgroundColorHex: '#FFFFFF',
      accentColorHex: '#A6E7E5',
      onAccentColorHex: '#042F1D',
      nameFontWeight: FontWeight.w400,
      descriptionFontWeight: FontWeight.w400,
      venueFontWeight: FontWeight.w600,
    ),
    // Theme 4: Playfair Display
  EventTheme(
      id: 'playfair_display',
      name: 'Playfair Display',
      fontFamily: 'Playfair Display',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#CAB9EC',
      onDetailBackgroundColorHex: '#270329',
      accentColorHex: '#790094',
      onAccentColorHex: '#FFFFFF',
      nameFontWeight: FontWeight.w500,
      descriptionFontWeight: FontWeight.w400,
      venueFontWeight: FontWeight.w600,
    ),
    // Theme 5: Roboto
    EventTheme(
      id: 'roboto',
      name: 'Roboto',
      fontFamily: 'Roboto',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#0F172A',
      onDetailBackgroundColorHex: '#FFFFFF',
      accentColorHex: '#3B82F6',
      onAccentColorHex: '#FFFFFF',
      nameFontWeight: FontWeight.w700,
      descriptionFontWeight: FontWeight.w300,
      venueFontWeight: FontWeight.w400,
    ),
    // Theme 6: Montserrat
    EventTheme(
      id: 'montserrat',
      name: 'Montserrat',
      fontFamily: 'Montserrat',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#1E40AF',
      onDetailBackgroundColorHex: '#FFFFFF',
      accentColorHex: '#FBBF24',
      onAccentColorHex: '#1E40AF',
      nameFontWeight: FontWeight.w700,
      descriptionFontWeight: FontWeight.w400,
      venueFontWeight: FontWeight.w500,
    ),
    // Theme 7: Lato
    EventTheme(
      id: 'lato',
      name: 'Lato',
      fontFamily: 'Lato',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#FEF3E2',
      onDetailBackgroundColorHex: '#7C2D12',
      accentColorHex: '#EA580C',
      onAccentColorHex: '#FFFFFF',
      nameFontWeight: FontWeight.w700,
      descriptionFontWeight: FontWeight.w400,
      venueFontWeight: FontWeight.w500,
    ),
    // Theme 8: Open Sans
    EventTheme(
      id: 'open_sans',
      name: 'Open Sans',
      fontFamily: 'Open Sans',
      backgroundColorHex: '#FFFFFF',
      detailBackgroundColorHex: '#065F46',
      onDetailBackgroundColorHex: '#FFFFFF',
      accentColorHex: '#10B981',
      onAccentColorHex: '#FFFFFF',
      nameFontWeight: FontWeight.w600,
      descriptionFontWeight: FontWeight.w300,
      venueFontWeight: FontWeight.w400,
    ),
  ];

  static EventTheme getThemeById(String id) {
    try {
      return predefinedThemes.firstWhere((theme) => theme.id == id);
    } catch (e) {
      return predefinedThemes.first;
    }
  }

  static List<String> get themeNames =>
      predefinedThemes.map((theme) => theme.name).toList();
}
