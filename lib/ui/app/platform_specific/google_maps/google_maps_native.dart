import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    return _GoogleMapsNative(
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
      markerTitle: markerTitle,
    );
  }
}

class _GoogleMapsNative extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final String markerTitle;

  const _GoogleMapsNative({
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.markerTitle,
  });

  @override
  State<_GoogleMapsNative> createState() => _GoogleMapsNativeState();
}

class _GoogleMapsNativeState extends State<_GoogleMapsNative> {
  late GoogleMapController mapController;
  late final Marker marker;
  late final CameraPosition initialCameraPosition;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: widget.zoom,
    );

    marker = Marker(
      markerId: const MarkerId('mainMarker'),
      position: LatLng(widget.latitude, widget.longitude),
      infoWindow: InfoWindow(title: widget.markerTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      markers: {marker},
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: true,
      compassEnabled: true,
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
