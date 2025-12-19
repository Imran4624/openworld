import 'package:flutter/material.dart';
import 'google_maps_interface.dart';

class PlatformGoogleMaps extends PlatformGoogleMapsInterface {
  const PlatformGoogleMaps({
    super.key,
    required super.latitude,
    required super.longitude,
    required super.zoom,
    required super.markerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Google Maps is not supported on this platform."));
  }
}
