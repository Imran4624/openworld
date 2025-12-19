import 'package:flutter_boilerplate/ui/app/shared.dart';

class GoogleMapsUrlParser {
  static Map<String, dynamic> parseUrl(String url) {
    // Default values
    Map<String, dynamic> result = {
      'latitude': 0.0,
      'longitude': 0.0,
      'zoom': 12.0
    };

    try {
      // Extract coordinates from URL
      RegExp coordsRegex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+),(\d+)z');
      var match = coordsRegex.firstMatch(url);

      if (match != null) {
        result['latitude'] = double.parse(match.group(1)!);
        result['longitude'] = double.parse(match.group(2)!);
        result['zoom'] = double.parse(match.group(3)!);
      } else {
        // Try alternate format (sometimes found in place URLs)
        RegExp placeRegex = RegExp(r'/@(-?\d+\.\d+),(-?\d+\.\d+)');
        match = placeRegex.firstMatch(url);
        if (match != null) {
          result['latitude'] = double.parse(match.group(1)!);
          result['longitude'] = double.parse(match.group(2)!);
        }
      }
    } catch (e) {
      logError(' Error parsing Google Maps URL: $e');
    }

    return result;
  }
}
