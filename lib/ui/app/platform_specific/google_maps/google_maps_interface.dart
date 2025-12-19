import 'package:flutter/material.dart';

abstract class PlatformGoogleMapsInterface extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final String markerTitle;

  const PlatformGoogleMapsInterface({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.markerTitle,
  });
}
