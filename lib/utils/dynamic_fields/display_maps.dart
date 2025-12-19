import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/platform_specific/google_maps/google_maps.dart';
import 'package:flutter_boilerplate/utils/maps/apple_maps_url_parser.dart';
import 'package:flutter_boilerplate/utils/maps/google_maps_url_parser.dart';

const googleMapsApiKey = "AIzaSyAkyoOQkXsMJMt7zw-gyuInIPU9Z3--Vxk";
const what3WordsApiKey = "OW1CS3PC"; //not functinoal

Widget buildMapPreview(String? description) {
  if (description == null || description.isEmpty) {
    return const SizedBox.shrink();
  }

  MapLink? extractMapLink(String text) {
    final googleMapsRegex = RegExp(
      r'https?:\/\/(www\.)?(google\.com\/maps|goo\.gl\/maps)\/[^\s]+',
      caseSensitive: false,
    );
    final appleMapsRegex = RegExp(
      r'https?:\/\/(www\.)?(maps\.apple\.com)\/[^\s]+',
      caseSensitive: false,
    );
    final what3wordsRegex = RegExp(
      r'(https?:\/\/(www\.)?what3words\.com\/[^\s]+|///[\w\.]+\.[\w\.]+\.[\w\.]+)',
      caseSensitive: false,
    );

    String? url;
    MapType type = MapType.unknown;

    if (googleMapsRegex.hasMatch(text)) {
      url = googleMapsRegex.firstMatch(text)?.group(0);
      type = MapType.google;
    } else if (appleMapsRegex.hasMatch(text)) {
      url = appleMapsRegex.firstMatch(text)?.group(0);
      type = MapType.apple;
    } else if (what3wordsRegex.hasMatch(text)) {
      final match = what3wordsRegex.firstMatch(text)?.group(0);
      if (match != null) {
        if (match.startsWith('///')) {
          url = 'https://what3words.com/$match';
        } else {
          url = match;
        }
        type = MapType.what3words;
      }
    }

    if (url != null) {
      return MapLink(
        url: url,
        type: type,
      );
    }
    return null;
  }

  Map<String, dynamic> coordinates = {
    'latitude': 0.0,
    'longitude': 0.0,
    'zoom': 0.0
  };
  final mapLink = extractMapLink(description);
  if (mapLink == null) return const SizedBox.shrink();
  if (mapLink.type == MapType.google) {
    coordinates = GoogleMapsUrlParser.parseUrl(mapLink.url);
  } else if (mapLink.type == MapType.apple) {
    coordinates = AppleMapsUrlParser.parseUrl(mapLink.url);
  }

  return SizedBox(
    width: double.infinity,
    height: 150,
    child: GoogleMapsWidget(
      latitude: coordinates['latitude'],
      longitude: coordinates['longitude'],
      zoom: coordinates['zoom'],
    ),
  );
}

class MapLink {
  final String url;
  final MapType type;

  MapLink({
    required this.url,
    required this.type,
  });
}

enum MapType {
  google,
  apple,
  what3words,
  unknown,
}
