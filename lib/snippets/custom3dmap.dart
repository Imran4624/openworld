import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'marathon_route.dart'; // Import the file containing marathonRoute
import 'package:flutter_boilerplate/data/models/entities.dart';

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'London Marathon 3D Map',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const LondonMarathonMapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LondonMarathonMapScreen extends StatefulWidget {
  const LondonMarathonMapScreen({Key? key}) : super(key: key);

  @override
  State<LondonMarathonMapScreen> createState() =>
      _LondonMarathonMapScreenState();
}

class _LondonMarathonMapScreenState extends State<LondonMarathonMapScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;
  bool _showRunnerDensity = true;
  bool _showCrowdDensity = true;
  bool _show3DEffect = true;

  // Using externally defined marathonRoute from marathon_route.dart
  // This will contain 900+ exact coordinates of the complete route

  // User density data (simulated - higher values represent more runners in that section)
  final List<double> _runnerDensity = List.generate(900, (index) {
    // Exponential decay from start to finish - more runners at the beginning, fewer at the end
    return 0.95 * math.exp(-0.0025 * index);
  });

  // Crowd density data (simulated - varies along the route with hotspots at key locations)
  final List<double> _crowdDensity = List.generate(900, (index) {
    // Base random variance
    double base = 0.3 + (math.Random().nextDouble() * 0.3);

    // Create hotspots at key locations (start, middle, finish, and some random points)
    if (index < 50) {
      // Start area - very high density
      return 0.8 + (math.Random().nextDouble() * 0.2);
    } else if (index > 850) {
      // Finish area - very high density
      return 0.9 + (math.Random().nextDouble() * 0.1);
    } else if (index > 400 && index < 500) {
      // Middle of the route - high density
      return 0.7 + (math.Random().nextDouble() * 0.2);
    } else if (index % 100 < 20) {
      // Popular viewing areas along the route
      return 0.6 + (math.Random().nextDouble() * 0.3);
    }

    return base;
  });

  @override
  Widget build(BuildContext context) {
    

    final actionsWidget = Row(
      children: [
        Row(
          children: [
            const Text('Runner', style: TextStyle(fontSize: 12)),
            Switch(
              value: _showRunnerDensity,
              onChanged: (value) {
                setState(() {
                  _showRunnerDensity = value;
                });
              },
              activeColor: Colors.red,
            ),
          ],
        ),
        Row(
          children: [
            const Text('Crowd', style: TextStyle(fontSize: 12)),
            Switch(
              value: _showCrowdDensity,
              onChanged: (value) {
                setState(() {
                  _showCrowdDensity = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
        Row(
          children: [
            const Text('3D', style: TextStyle(fontSize: 12)),
            Switch(
              value: _show3DEffect,
              onChanged: (value) {
                setState(() {
                  _show3DEffect = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(width: 10),
      ],
    );

    return ListScaffold(
      entityType: EntityType.company,
      appBarTitle: const Text('London Marathon 3D Map'),
      
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: const LatLng(51.5007, -0.1246), // London center
              zoom: _currentZoom,
              maxZoom: 18.0,
              minZoom: 10.0,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _currentZoom = position.zoom ?? _currentZoom;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                backgroundColor: const Color(0xFF1a1a1a),
                tileBuilder: (context, Widget child, TileImage tile) {
                  // Apply sophisticated monochrome filter to map tiles
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.33, 0.33, 0.33, 0, 0,
                      0.33, 0.33, 0.33, 0, 0,
                      0.33, 0.33, 0.33, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        1.1, 0, 0, 0, -0.1,
                        0, 1.1, 0, 0, -0.1,
                        0, 0, 1.1, 0, -0.1,
                        0, 0, 0, 1, 0,
                      ]),
                      child: child,
                    ),
                  );
                },
              ),

              // Base route line
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: marathonRoute,
                    strokeWidth: 5.0,
                    color: Colors.white.withOpacity(0.7),
                    borderColor: Colors.black,
                    borderStrokeWidth: 1.0,
                  ),
                ],
              ),

              // Shadow for 3D effect
              if (_show3DEffect)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: marathonRoute
                          .map((point) => LatLng(point.latitude + 0.0001,
                              point.longitude + 0.0001))
                          .toList(),
                      strokeWidth: 4.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),

              // Runner density visualization
              if (_showRunnerDensity)
                PolylineLayer(
                  polylines: _createRunnerDensityPolylines(),
                ),

              // Crowd density visualization (on both sides of track)
              if (_showCrowdDensity)
                PolylineLayer(
                  polylines: _createCrowdDensityPolylines(),
                ),

              // Mile markers
              MarkerLayer(
                markers: _createMileMarkers(),
              ),
            ],
          ),

          // Zoom controls
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                _buildZoomButton(
                  icon: Icons.add,
                  onPressed: () {
                    setState(() {
                      _currentZoom = math.min(_currentZoom + 1, 18.0);
                      _mapController.move(_mapController.center, _currentZoom);
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildZoomButton(
                  icon: Icons.remove,
                  onPressed: () {
                    setState(() {
                      _currentZoom = math.max(_currentZoom - 1, 10.0);
                      _mapController.move(_mapController.center, _currentZoom);
                    });
                  },
                ),
              ],
            ),
          ),

          // Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showRunnerDensity) ...[
                    const Text('Runner Density',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.green,
                                Colors.yellow,
                                Colors.orange,
                                Colors.red
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Low',
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70)),
                        SizedBox(width: 120),
                        Text('High',
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_showCrowdDensity) ...[
                    const Text('Crowd Density',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade50,
                                Colors.blue.shade300,
                                Colors.blue.shade500,
                                Colors.blue.shade700
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Low',
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70)),
                        SizedBox(width: 120),
                        Text('High',
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: Colors.black,
        iconSize: 20,
      ),
    );
  }

  List<Polyline> _createRunnerDensityPolylines() {
    List<Polyline> polylines = [];

    // Create density polylines in segments
    // For better performance, we'll create segments for every 5 points
    int segmentSize = 5;

    for (int i = 0; i < marathonRoute.length - segmentSize; i += segmentSize) {
      double avgDensity = 0;
      for (int j = 0; j < segmentSize; j++) {
        if (i + j < _runnerDensity.length) {
          avgDensity += _runnerDensity[i + j];
        }
      }
      avgDensity /= segmentSize;

      List<LatLng> segmentPoints = [];
      for (int j = 0; j <= segmentSize; j++) {
        if (i + j < marathonRoute.length) {
          segmentPoints.add(marathonRoute[i + j]);
        }
      }

      if (segmentPoints.length > 1) {
        polylines.add(
          Polyline(
            points: segmentPoints,
            strokeWidth: 3.0 + (avgDensity * 5.0), // Width based on density
            color: _getRunnerDensityColor(avgDensity),
            borderStrokeWidth: 0,
          ),
        );
      }
    }

    return polylines;
  }

  List<Polyline> _createCrowdDensityPolylines() {
    List<Polyline> polylines = [];

    // Create density polylines on both sides of the track
    // We'll offset points to create "sidelines" representing crowds
    int segmentSize = 5;
    double offsetDistance = 0.0003; // Offset from the main route

    // Process segments for better performance
    for (int i = 0; i < marathonRoute.length - segmentSize; i += segmentSize) {
      double avgDensity = 0;
      for (int j = 0; j < segmentSize; j++) {
        if (i + j < _crowdDensity.length) {
          avgDensity += _crowdDensity[i + j];
        }
      }
      avgDensity /= segmentSize;

      if (i + segmentSize < marathonRoute.length) {
        // Create segments for left and right side of the track
        List<LatLng> leftSidePoints = [];
        List<LatLng> rightSidePoints = [];

        for (int j = 0; j <= segmentSize; j++) {
          if (i + j + 1 < marathonRoute.length) {
            final LatLng current = marathonRoute[i + j];
            final LatLng next = marathonRoute[i + j + 1];

            // Calculate perpendicular offset
            final double dx = next.longitude - current.longitude;
            final double dy = next.latitude - current.latitude;
            final double length = math.sqrt(dx * dx + dy * dy);

            if (length > 0) {
              final double offsetX = -dy / length * offsetDistance;
              final double offsetY = dx / length * offsetDistance;

              // Left side
              leftSidePoints.add(LatLng(
                  current.latitude + offsetY, current.longitude + offsetX));

              // Right side
              rightSidePoints.add(LatLng(
                  current.latitude - offsetY, current.longitude - offsetX));
            }
          }
        }

        // Add polylines for left and right sides
        if (leftSidePoints.length > 1) {
          polylines.add(
            Polyline(
              points: leftSidePoints,
              strokeWidth: 1.0 + (avgDensity * 10.0), // Width based on density
              color: _getCrowdDensityColor(avgDensity),
              borderStrokeWidth: 0,
            ),
          );
        }

        if (rightSidePoints.length > 1) {
          polylines.add(
            Polyline(
              points: rightSidePoints,
              strokeWidth: 1.0 + (avgDensity * 10.0), // Width based on density
              color: _getCrowdDensityColor(avgDensity),
              borderStrokeWidth: 0,
            ),
          );
        }
      }
    }

    return polylines;
  }

  List<Marker> _createMileMarkers() {
    List<Marker> markers = [];

    // Add start marker
    markers.add(
      Marker(
        point: marathonRoute.first,
        width: 80,
        height: 40,
        builder: (context) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'START',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Add finish marker
    markers.add(
      Marker(
        point: marathonRoute.last,
        width: 80,
        height: 40,
        builder: (context) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'FINISH',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Create exactly 26 mile markers along the route
    // London Marathon is ~26.2 miles
    int totalMiles = 26;
    int pointsPerMile = marathonRoute.length ~/ totalMiles;

    for (int mile = 1; mile <= totalMiles; mile++) {
      // Get index for this mile marker
      int index = mile * pointsPerMile;
      if (index >= marathonRoute.length) continue;

      LatLng point = marathonRoute[index];

      markers.add(
        Marker(
          point: point,
          width: 40,
          height: 40,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$mile',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Color _getRunnerDensityColor(double value) {
    // Gradient from green (low) to red (high)
    if (value < 0.25) {
      return Colors.green.shade500;
    } else if (value < 0.5) {
      return Colors.yellow.shade600;
    } else if (value < 0.75) {
      return Colors.orange.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  Color _getCrowdDensityColor(double value) {
    // Blue gradient for crowd density
    if (value < 0.25) {
      return Colors.blue.shade200.withOpacity(0.7);
    } else if (value < 0.5) {
      return Colors.blue.shade400.withOpacity(0.7);
    } else if (value < 0.75) {
      return Colors.blue.shade600.withOpacity(0.7);
    } else {
      return Colors.blue.shade800.withOpacity(0.7);
    }
  }
}