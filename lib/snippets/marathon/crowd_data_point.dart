import 'package:latlong2/latlong.dart';

class CrowdDataPoint {
  final LatLng position;
  final double density; // 0.0 to 1.0
  final bool isOnRoute; // Whether this point is along the route or elsewhere

  CrowdDataPoint(this.position, this.density, this.isOnRoute);
}

// Sample data - in your real app, this would be populated from GPS data
