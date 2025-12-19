import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/snippets/marathon/crowd_data_point.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'marathon_route.dart'; // Import the file containing marathonRoute

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
  
  static const String route = '/marathon_map';

  @override
  State<LondonMarathonMapScreen> createState() =>
      _LondonMarathonMapScreenState();
}

class _LondonMarathonMapScreenState extends State<LondonMarathonMapScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;
  bool _showIndividualPeople = false;

  bool _showRunnerDensity = true;
  bool _showCrowdDensity = true;
  List<CrowdDataPoint> _crowdData = [];

  String _selectedMapStyle = 'monochrome';

  // Map style options
  final Map<String, String> _mapStyles = {
    'monochrome':
        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    'dark': 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
    'satellite':
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    'streets': 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  };

  @override
  void initState() {
    super.initState();
    _initializeSampleCrowdData();
  }

// Sample data for crowd outside the route - in real app, this would come from GPS data
  final List<LatLng> _offRouteCrowdPositions = [
    // Start area (Greenwich Park) crowd points
    LatLng(51.4765, -0.0016), LatLng(51.4768, -0.0019),
    LatLng(51.4761, -0.0022),
    LatLng(51.4763, -0.0028), LatLng(51.4769, -0.0032),
    LatLng(51.4772, -0.0025),
    LatLng(51.4758, -0.0035), LatLng(51.4755, -0.0025),
    LatLng(51.4760, -0.0040),
    LatLng(51.4775, -0.0020), LatLng(51.4777, -0.0030),
    LatLng(51.4780, -0.0025),
    LatLng(51.4773, -0.0038), LatLng(51.4767, -0.0045),
    LatLng(51.4772, -0.0048),
    // Add more crowd points near start

    // Finish area (The Mall) crowd points
    LatLng(51.5040, -0.1390), LatLng(51.5042, -0.1400),
    LatLng(51.5038, -0.1395),
    LatLng(51.5045, -0.1385), LatLng(51.5035, -0.1380),
    LatLng(51.5048, -0.1370),
    LatLng(51.5032, -0.1400), LatLng(51.5046, -0.1410),
    LatLng(51.5038, -0.1415),
    LatLng(51.5050, -0.1385), LatLng(51.5030, -0.1390),
    LatLng(51.5035, -0.1402),
    LatLng(51.5042, -0.1365), LatLng(51.5037, -0.1355),
    LatLng(51.5033, -0.1365),
    // Add more crowd points near finish

    // Tower Hill viewing area
    LatLng(51.5085, -0.0775), LatLng(51.5087, -0.0780),
    LatLng(51.5082, -0.0778),
    LatLng(51.5084, -0.0785), LatLng(51.5089, -0.0770),
    LatLng(51.5086, -0.0765),

    // Canary Wharf viewing area
    LatLng(51.5055, -0.0225), LatLng(51.5058, -0.0230),
    LatLng(51.5052, -0.0228),
    LatLng(51.5050, -0.0235), LatLng(51.5060, -0.0240),
    LatLng(51.5056, -0.0245),

    // Add more points as needed for other popular viewing areas
  ];

// Densities for each crowd point (0.0 to 1.0)
  final List<double> _offRouteCrowdDensities = List.generate(
      100, // Make sure this matches the length of _offRouteCrowdPositions
      (index) {
    // Higher density at start and finish areas
    if (index < 15)
      return 0.7 + (math.Random().nextDouble() * 0.3); // Start area
    if (index >= 15 && index < 30)
      return 0.8 + (math.Random().nextDouble() * 0.2); // Finish area
    return 0.4 + (math.Random().nextDouble() * 0.4); // Other areas
  });
  // Using marathonRoute from external file (900+ coordinates)

  // User density data (simulated)
  // This will be replaced with actual data
  final List<double> _runnerDensity = List.generate(900, (index) {
    // Exponential decay from start to finish - more runners at the beginning, fewer at the end
    return 0.95 * math.exp(-0.0025 * index);
  });

  // Crowd density data for left and right sides (simulated)
  // These will be replaced with actual data
  final List<double> _leftCrowdDensity = List.generate(900, (index) {
    double base = 0.3 + (math.Random().nextDouble() * 0.3);

    // Create hotspots at key locations
    if (index < 50) return 0.8 + (math.Random().nextDouble() * 0.2);
    if (index > 850) return 0.9 + (math.Random().nextDouble() * 0.1);
    if (index > 400 && index < 500)
      return 0.7 + (math.Random().nextDouble() * 0.2);
    if (index % 100 < 20) return 0.6 + (math.Random().nextDouble() * 0.3);

    return base;
  });

  final List<double> _rightCrowdDensity = List.generate(900, (index) {
    double base = 0.2 + (math.Random().nextDouble() * 0.4);

    // Different pattern for right side
    if (index < 60) return 0.7 + (math.Random().nextDouble() * 0.2);
    if (index > 800) return 0.8 + (math.Random().nextDouble() * 0.2);
    if (index > 300 && index < 450)
      return 0.7 + (math.Random().nextDouble() * 0.2);
    if (index % 150 < 30) return 0.5 + (math.Random().nextDouble() * 0.3);

    return base;
  });

  @override
  Widget build(BuildContext context) {
    final actionsWidget = Row(
      children: [
        Row(
          children: [
            StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                final appTheme = AppTheme.getThemeColors(state.prefState.enableDarkMode);
                return Text('Dots', style: TextStyle(fontSize: 12, color: appTheme.text));
              },
            ),
            Switch(
              value: _showIndividualPeople,
              onChanged: (value) {
                setState(() {
                  _showIndividualPeople = value;
                  if (value) {
                    _showCrowdDensity = true;
                  }
                });
              },
              activeColor: Colors.purple,
            ),
          ],
        ),
        Row(
          children: [
            StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                final appTheme = AppTheme.getThemeColors(state.prefState.enableDarkMode);
                return Text('Runner', style: TextStyle(fontSize: 12, color: appTheme.text));
              },
            ),
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
            StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                final appTheme = AppTheme.getThemeColors(state.prefState.enableDarkMode);
                return Text('Crowd', style: TextStyle(fontSize: 12, color: appTheme.text));
              },
            ),
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
        IconButton(
          icon: const Icon(Icons.layers),
          onPressed: _showMapStyleSelector,
          tooltip: 'Change Map Style',
        ),
        const SizedBox(width: 10),
      ],
    );

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return ListScaffold(
          entityType: EntityType.company, // Use appropriate entity type
          appBarTitle: const Text('London Marathon 3D Map',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          appBarActions: [actionsWidget],
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: const LatLng(51.5007, -0.1246),
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
                    urlTemplate: _mapStyles[_selectedMapStyle],
                    subdomains: const ['a', 'b', 'c', 'd'],
                    backgroundColor: const Color(0xFF1a1a1a),
                    tileBuilder: _selectedMapStyle == 'monochrome'
                        ? (context, Widget child, TileImage tile) {
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
                          }
                        : null,
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: marathonRoute,
                        strokeWidth: 4.0,
                        color: _selectedMapStyle == 'dark'
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.7),
                        borderColor: _selectedMapStyle == 'dark'
                            ? Colors.black
                            : Colors.white,
                        borderStrokeWidth: 1.0,
                      ),
                    ],
                  ),
                  if (_showRunnerDensity)
                    PolylineLayer(
                      polylines: _createRunnerDensityPolylines(),
                    ),
                  if (_showCrowdDensity)
                    PolylineLayer(
                      polylines: _createCrowdDensityPolylines(true),
                    ),
                  if (_showCrowdDensity)
                    PolylineLayer(
                      polylines: _createCrowdDensityPolylines(false),
                    ),
                  MarkerLayer(
                    markers: _createMileMarkers(),
                  ),
                  MarkerLayer(
                    markers: _createCrowdMarkers(),
                  ),
                ],
              ),
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
                    const SizedBox(height: 8),
                    _buildNavButton(
                      icon: Icons.navigation,
                      onPressed: _launchNavigation,
                    ),
                  ],
                ),
              ),
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
                                style: TextStyle(fontSize: 10, color: Colors.white70)),
                            SizedBox(width: 120),
                            Text('High',
                                style: TextStyle(fontSize: 10, color: Colors.white70)),
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
                                    Colors.blue.shade100,
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
                                style: TextStyle(fontSize: 10, color: Colors.white70)),
                            SizedBox(width: 120),
                            Text('High',
                                style: TextStyle(fontSize: 10, color: Colors.white70)),
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
      },
    );
  }

  void _showMapStyleSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Map Style'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildMapStyleOption('Monochrome', 'monochrome'),
              _buildMapStyleOption('Dark', 'dark'),
              _buildMapStyleOption('Satellite', 'satellite'),
              _buildMapStyleOption('Streets', 'streets'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStyleOption(String name, String style) {
    return ListTile(
      title: Text(name),
      selected: _selectedMapStyle == style,
      onTap: () {
        setState(() {
          _selectedMapStyle = style;
        });
        Navigator.pop(context);
      },
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
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildNavButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
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
        color: Colors.white,
        iconSize: 20,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  // Launch navigation to Google Maps for directions
  void _launchNavigation() {
    // Show dialog to select current position on route
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Navigation'),
        content: const Text('Choose an option for navigation:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openGoogleMapsNavigation('current');
            },
            child: const Text('From Current Location'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openGoogleMapsNavigation('start');
            },
            child: const Text('From Start'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _openGoogleMapsNavigation(String from) {
    LatLng destination = marathonRoute.last; // Finish line
    LatLng origin =
        from == 'start' ? marathonRoute.first : _mapController.center;

    // Create Google Maps URL
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=walking';

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  List<Polyline> _createRunnerDensityPolylines() {
    List<Polyline> polylines = [];

    // Create density polylines in segments
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
            strokeWidth: 2.0 + (avgDensity * 4.0), // Width based on density
            color: _getRunnerDensityColor(avgDensity),
            borderStrokeWidth: 0,
          ),
        );
      }
    }

    return polylines;
  }

  List<Polyline> _createCrowdDensityPolylines(bool isLeftSide) {
    List<Polyline> polylines = [];
// Don't process if crowd toggle is off
    if (!_showCrowdDensity) return polylines;
    // Create density polylines on one side of the track
    int segmentSize = 5;

    // Adjust offset distance based on zoom level
    // Scale from 0.0001 (zoomed in) to 0.0003 (zoomed out)
    double baseOffset = 0.0001;
    double zoomFactor = (_currentZoom <= 14)
        ? 1.0 + (14 - _currentZoom) * 0.2
        : math.max(0.5, 1.0 - (_currentZoom - 14) * 0.1);
    double offsetDistance = baseOffset * zoomFactor;

    // Special handling for Tower Bridge (approximate coordinates)
    // Tower Bridge is roughly between these points in the marathon route
    final towerBridgeStart = LatLng(51.5055, -0.0750);
    final towerBridgeEnd = LatLng(51.5075, -0.0733);

    // Process segments for better performance
    for (int i = 0; i < marathonRoute.length - segmentSize; i += segmentSize) {
      // Get appropriate density data based on side
      List<double> crowdDensity =
          isLeftSide ? _leftCrowdDensity : _rightCrowdDensity;

      double avgDensity = 0;
      for (int j = 0; j < segmentSize; j++) {
        if (i + j < crowdDensity.length) {
          avgDensity += crowdDensity[i + j];
        }
      }
      avgDensity /= segmentSize;

      if (i + segmentSize < marathonRoute.length) {
        List<LatLng> sidePoints = [];

        for (int j = 0; j <= segmentSize; j++) {
          if (i + j + 1 < marathonRoute.length) {
            final LatLng current = marathonRoute[i + j];
            final LatLng next = marathonRoute[i + j + 1];

            // Check if we're on Tower Bridge
            bool isOnTowerBridge = _isPointNearLine(
                current, towerBridgeStart, towerBridgeEnd, 0.002);

            // Adjust offset for Tower Bridge - keep crowds strictly on sides
            double currentOffsetDistance =
                isOnTowerBridge ? offsetDistance * 0.5 : offsetDistance;

            // Don't place crowds on water when on Tower Bridge if a certain side
            if (isOnTowerBridge) {
              // For Tower Bridge, we want to ensure crowds stay on the walkways
              // North side of bridge is left, south side is right
              // Skip this segment if we're on the wrong side for water sections
              if ((current.latitude > 51.5065 && !isLeftSide) ||
                  (current.latitude < 51.5065 && isLeftSide)) {
                continue;
              }
            }

            // Calculate perpendicular offset with better precision
            final double dx = next.longitude - current.longitude;
            final double dy = next.latitude - current.latitude;
            final double length = math.sqrt(dx * dx + dy * dy);

            if (length > 0) {
              final double offsetX = -dy / length * currentOffsetDistance;
              final double offsetY = dx / length * currentOffsetDistance;

              // Apply offset based on side
              if (isLeftSide) {
                sidePoints.add(LatLng(
                    current.latitude + offsetY, current.longitude + offsetX));
              } else {
                sidePoints.add(LatLng(
                    current.latitude - offsetY, current.longitude - offsetX));
              }
            }
          }
        }

        // Add crowd visualization
        if (sidePoints.length > 1) {
          if (_showIndividualPeople && _currentZoom >= 16) {
            // Generate dots for people when zoomed in close enough
            for (int p = 0; p < sidePoints.length - 1; p++) {
              // Create more dots for higher density areas
              int numPeople = (avgDensity * 10).round();

              for (int person = 0; person < numPeople; person++) {
                // Calculate random position between two points
                double t = math.Random().nextDouble();
                double lat = sidePoints[p].latitude +
                    t * (sidePoints[p + 1].latitude - sidePoints[p].latitude);
                double lng = sidePoints[p].longitude +
                    t * (sidePoints[p + 1].longitude - sidePoints[p].longitude);

                // Add small random offset to prevent perfectly straight lines of people
                lat += (math.Random().nextDouble() - 0.5) * 0.00005;
                lng += (math.Random().nextDouble() - 0.5) * 0.00005;

                polylines.add(Polyline(
                  points: [LatLng(lat, lng), LatLng(lat, lng)],
                  strokeWidth: 2.0,
                  color: _getCrowdDensityColor(avgDensity),
                  borderStrokeWidth: 0,
                ));
              }
            }
          } else {
            // Use dotted polyline for crowd at lower zoom levels
            polylines.add(
              Polyline(
                points: sidePoints,
                strokeWidth:
                    math.min(1.0 + (avgDensity * 4.0), 5.0), // Cap max width
                color: _getCrowdDensityColor(avgDensity),
                borderStrokeWidth: 0,
                isDotted: true,
                strokeCap: StrokeCap.round,
              ),
            );
          }
        }
      }
    }

    return polylines;
  }

// Helper function to detect if a point is near a line segment
  bool _isPointNearLine(
      LatLng point, LatLng lineStart, LatLng lineEnd, double threshold) {
    // Calculate the distance from point to line
    double numerator = (lineEnd.longitude - lineStart.longitude) *
            (lineStart.latitude - point.latitude) -
        (lineStart.longitude - point.longitude) *
            (lineEnd.latitude - lineStart.latitude);
    numerator = numerator.abs();

    double denominator = math.sqrt(
        math.pow(lineEnd.longitude - lineStart.longitude, 2) +
            math.pow(lineEnd.latitude - lineStart.latitude, 2));

    if (denominator == 0) return false;

    double distance = numerator / denominator;

    // Check if point is within threshold distance of the line
    return distance < threshold;
  }

// Method to update crowd positions with real GPS data
// Call this method when you receive new GPS data
  void updateOffRouteCrowdPositions(
      List<LatLng> positions, List<double> densities) {
    setState(() {
      // Update stored positions and densities
      _offRouteCrowdPositions.clear();
      _offRouteCrowdPositions.addAll(positions);

      _offRouteCrowdDensities.clear();
      _offRouteCrowdDensities.addAll(densities);
    });
  }

  void _initializeSampleCrowdData() {
    _crowdData = [];

    // Add on-route crowd data (left side)
    for (int i = 0; i < marathonRoute.length; i += 5) {
      if (i < _leftCrowdDensity.length && i < marathonRoute.length) {
        // Calculate offset for left side
        if (i + 1 < marathonRoute.length) {
          final LatLng current = marathonRoute[i];
          final LatLng next = marathonRoute[i + 1];

          // Calculate perpendicular offset
          final double dx = next.longitude - current.longitude;
          final double dy = next.latitude - current.latitude;
          final double length = math.sqrt(dx * dx + dy * dy);

          if (length > 0) {
            final double offsetDistance = 0.0002;
            final double offsetX = -dy / length * offsetDistance;
            final double offsetY = dx / length * offsetDistance;

            // Add left side point
            // _crowdData.add(CrowdDataPoint(
            //     LatLng(current.latitude + offsetY, current.longitude + offsetX),
            //     _leftCrowdDensity[i],
            //     true));
          }
        }
      }
    }

    // Add on-route crowd data (right side)
    for (int i = 0; i < marathonRoute.length; i += 5) {
      if (i < _rightCrowdDensity.length && i < marathonRoute.length) {
        // Calculate offset for right side
        if (i + 1 < marathonRoute.length) {
          final LatLng current = marathonRoute[i];
          final LatLng next = marathonRoute[i + 1];

          // Calculate perpendicular offset
          final double dx = next.longitude - current.longitude;
          final double dy = next.latitude - current.latitude;
          final double length = math.sqrt(dx * dx + dy * dy);

          if (length > 0) {
            final double offsetDistance = 0.0002;
            final double offsetX = -dy / length * offsetDistance;
            final double offsetY = dx / length * offsetDistance;

            // Add right side point
            // _crowdData.add(CrowdDataPoint(
            //     LatLng(current.latitude - offsetY, current.longitude - offsetX),
            //     _rightCrowdDensity[i],
            //     true));
          }
        }
      }
    }

    // Add off-route crowd data (sample points for demonstration)
    // Start area (Greenwich Park)
    _addOffRouteCrowdCluster(LatLng(51.4765, -0.0016), 0.8, 15);

    // Finish area (The Mall)
    _addOffRouteCrowdCluster(LatLng(51.5040, -0.1390), 0.9, 15);

    // Tower Hill viewing area
    _addOffRouteCrowdCluster(LatLng(51.5085, -0.0775), 0.7, 6);

    // Canary Wharf viewing area
    _addOffRouteCrowdCluster(LatLng(51.5055, -0.0225), 0.6, 6);
  }

// Helper method to generate a cluster of crowd points
  void _addOffRouteCrowdCluster(LatLng center, double baseDensity, int count) {
    for (int i = 0; i < count; i++) {
      // Create random offset from center
      double offsetLat = (math.Random().nextDouble() - 0.5) * 0.001;
      double offsetLng = (math.Random().nextDouble() - 0.5) * 0.001;

      // Randomize density slightly
      double density = baseDensity * (0.8 + math.Random().nextDouble() * 0.4);

      // Add the data point
      _crowdData.add(CrowdDataPoint(
          LatLng(center.latitude + offsetLat, center.longitude + offsetLng),
          density,
          false // not on route
          ));
    }
  }

// STEP 3: Add this method to update with real data

// Call this when you receive real GPS data
  void updateCrowdData(List<CrowdDataPoint> newData) {
    setState(() {
      _crowdData = newData;
    });
  }

// STEP 4: Use this universal crowd visualization method

  List<Marker> _createCrowdMarkers() {
    // Don't show any markers if crowd toggle is off
    if (!_showCrowdDensity) return [];

    List<Marker> markers = [];

    for (CrowdDataPoint point in _crowdData) {
      // At high zoom levels with individual mode on, show more detailed dots
      if (_currentZoom >= 16 && _showIndividualPeople) {
        // For high density points, create multiple nearby dots
        int dotCount = (point.density * 4).round() + 1;

        for (int i = 0; i < dotCount; i++) {
          // Only create multiple dots for the first iteration or random chance
          if (i == 0 || math.Random().nextDouble() < point.density) {
            // Create small random offset for additional dots
            double offsetLat =
                i == 0 ? 0 : (math.Random().nextDouble() - 0.5) * 0.0001;
            double offsetLng =
                i == 0 ? 0 : (math.Random().nextDouble() - 0.5) * 0.0001;

            markers.add(
              Marker(
                point: LatLng(point.position.latitude + offsetLat,
                    point.position.longitude + offsetLng),
                width: 14,
                height: 14,
                builder: (context) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: point.isOnRoute
                        ? _getCrowdDensityColor(point.density)
                        : Colors.blue.withOpacity(0.5 + (point.density * 0.5)),
                  ),
                ),
              ),
            );
          }
        }
      } else {
        // At lower zoom levels, show simpler visualization
        markers.add(
          Marker(
            point: point.position,
            width: 12,
            height: 12,
            builder: (context) => Container(
              width: 6 + (point.density * 6),
              height: 6 + (point.density * 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: point.isOnRoute
                    ? _getCrowdDensityColor(point.density).withOpacity(0.7)
                    : Colors.blue.withOpacity(0.4 + (point.density * 0.3)),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  List<Marker> _createMileMarkers() {
    List<Marker> markers = [];

    // Add start marker
    markers.add(
      Marker(
        point: marathonRoute.first,
        width: 60,
        height: 30,
        builder: (context) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  fontSize: 10,
                ),
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
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
        width: 60,
        height: 30,
        builder: (context) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  fontSize: 10,
                ),
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
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

    // Calculate positions for exactly 26 mile markers
    // Create a marker every 1 mile along the 26.2 mile course

    // Total distance of marathon is 26.2 miles (42.195 km)
    // Need to place markers at the correct distances

    double totalDistanceInMiles = 26.2;
    int totalPoints = marathonRoute.length;

    for (int mile = 1; mile <= 26; mile++) {
      // Position based on proportion of total distance
      double milesCompleted = mile.toDouble();
      double proportion = milesCompleted / totalDistanceInMiles;

      // Calculate index in the route points array
      int pointIndex = (proportion * totalPoints).round();
      if (pointIndex >= marathonRoute.length) continue;

      LatLng point = marathonRoute[pointIndex];

      markers.add(
        Marker(
          point: point,
          width: 24,
          height: 24,
          builder: (context) => Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: _selectedMapStyle == 'dark'
                  ? Colors.white
                  : Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
              border: Border.all(
                  color:
                      _selectedMapStyle == 'dark' ? Colors.black : Colors.white,
                  width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$mile',
                style: TextStyle(
                  color:
                      _selectedMapStyle == 'dark' ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
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
