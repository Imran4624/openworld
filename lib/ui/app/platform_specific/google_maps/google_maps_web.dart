import 'dart:html';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'dart:ui_web' as ui_web;

class PlatformGoogleMaps extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final String markerTitle;

  const PlatformGoogleMaps({
    super.key,
    this.latitude = 51.5081124,
    this.longitude = -0.0759493,
    this.zoom = 17,
    this.markerTitle = 'Tower of London',
  });

  @override
  State<PlatformGoogleMaps> createState() => _PlatformGoogleMapsState();
}

class _PlatformGoogleMapsState extends State<PlatformGoogleMaps> {
  late final DivElement _mapElement;
  late final String _viewType;
  late final js.JsObject _map;

  @override
  void initState() {
    super.initState();
    _viewType = 'google-maps-${DateTime.now().millisecondsSinceEpoch}';
    _mapElement = DivElement()
      ..id = _viewType
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none';

    // Register the view factory
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      initializeMap();
      return _mapElement;
    });
  }

  void initializeMap() {
    if (js.context['google'] == null || js.context['google']['maps'] == null) {
      printL('Google Maps API is not loaded!');
      return;
    }
    final mapOptions = js.JsObject(js.context['Object']);
    mapOptions['zoom'] = widget.zoom;
    mapOptions['center'] = js.JsObject(js.context['google']['maps']['LatLng'],
        [widget.latitude, widget.longitude]);

    // Create the map
    _map = js.JsObject(
        js.context['google']['maps']['Map'], [_mapElement, mapOptions]);

    // Add marker
    final markerOptions = js.JsObject(js.context['Object']);
    markerOptions['position'] = js.JsObject(
        js.context['google']['maps']['LatLng'],
        [widget.latitude, widget.longitude]);
    markerOptions['map'] = _map;
    markerOptions['title'] = widget.markerTitle;
    markerOptions['animation'] =
        js.context['google']['maps']['Animation']['DROP'];

    // Create the marker
    js.JsObject(js.context['google']['maps']['Marker'], [markerOptions]);

    // Add info window with marker title
    final infoWindow = js.JsObject(js.context['google']['maps']['InfoWindow'], [
      {'content': widget.markerTitle}
    ]);

    // Show info window when marker is clicked
    final marker =
        js.JsObject(js.context['google']['maps']['Marker'], [markerOptions]);
    marker.callMethod('addListener', [
      'click',
      () {
        infoWindow.callMethod('open', [
          {'map': _map, 'anchor': marker}
        ]);
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _viewType,
    );
  }
}
