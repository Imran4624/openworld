import 'package:flutter_boilerplate/ui/app/shared.dart';

class AppleMapsUrlParser {
  static Map<String, dynamic> parseUrl(String url) {
    // Default values
    Map<String, dynamic> result = {
      'latitude': 0.0,
      'longitude': 0.0,
      'zoom': 12.0
    };

    try {
      // Extract coordinates from URL using ll parameter
      RegExp coordsRegex = RegExp(r'll=(-?\d+\.?\d*),(-?\d+\.?\d*)');
      var match = coordsRegex.firstMatch(url);

      if (match != null) {
        result['latitude'] = double.parse(match.group(1)!);
        result['longitude'] = double.parse(match.group(2)!);

        // Apple Maps doesn't explicitly show zoom in URL
        // We can try to determine zoom from lsp parameter if present
        RegExp zoomRegex = RegExp(r'lsp=(\d+)');
        var zoomMatch = zoomRegex.firstMatch(url);
        if (zoomMatch != null) {
          // Convert Apple's lsp value to approximate Google Maps zoom level
          // This is an approximation as Apple Maps uses different zoom scaling
          int lspValue = int.parse(zoomMatch.group(1)!);
          if (lspValue >= 9900) {
            // Very close zoom
            result['zoom'] = 18.0;
          } else if (lspValue >= 7000) {
            result['zoom'] = 15.0;
          } else if (lspValue >= 5000) {
            result['zoom'] = 13.0;
          } else {
            result['zoom'] = 12.0;
          }
        }
      }
    } catch (e) {
      logError(' Error parsing Apple Maps URL: $e');
    }

    return result;
  }
}
