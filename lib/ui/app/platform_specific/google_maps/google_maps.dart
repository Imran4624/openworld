import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/platform_specific/google_maps/google_maps_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/ui/app/platform_specific/google_maps/google_maps_web.dart'
    if (dart.library.io) 'package:flutter_boilerplate/ui/app/platform_specific/google_maps/google_maps_native.dart';
// if (dart.library.html) 'google_maps_web.dart'
// if (dart.library.io) 'google_maps_mobile.dart';

class GoogleMapsWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final String markerTitle;

  const GoogleMapsWidget({
    super.key,
    this.latitude = 51.5081124,
    this.longitude = -0.0759493,
    this.zoom = 17,
    this.markerTitle = 'Tower of London',
  });

  @override
  Widget build(BuildContext context) {
    return PlatformGoogleMaps(
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
      markerTitle: markerTitle,
    );
  }
}
