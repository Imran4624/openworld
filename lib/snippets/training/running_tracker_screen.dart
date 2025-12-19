import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'routes_data.dart';
import 'run_summary_screen.dart';

enum RunMode {
  freeRun,
  predefinedRoute,
}

class RunningTrackerScreen extends StatefulWidget {
  final RunMode runMode;
  final PredefinedRoute? predefinedRoute;

  const RunningTrackerScreen({
    Key? key,
    required this.runMode,
    this.predefinedRoute,
  }) : super(key: key);

  @override
  State<RunningTrackerScreen> createState() => _RunningTrackerScreenState();
}

class _RunningTrackerScreenState extends State<RunningTrackerScreen> {
  final MapController _mapController = MapController();

  // Initialize variables for tracking
  LatLng? _currentPosition;
  Position? _lastRecordedPosition;
  LatLng? _destinationPosition;
  List<LatLng> _routePoints = [];
  List<LatLng> _trackedPath = [];
  String _nextDirection = "Ready to start";
  bool _isTracking = false;
  Timer? _timer;
  List<Map<String, dynamic>> _directions = [];
  int _currentDirectionIndex = 0;
  List<Marker> _directionMarkers = [];
  double _heading = 0;

  // Run stats
  DateTime? _startTime;
  DateTime? _endTime;
  double _distanceTraveled = 0; // in meters
  List<SplitRun> _splits = []; // km splits
  double _currentSpeed = 0; // meters per second
  double _averageSpeed = 0; // meters per second
  double _currentPace = 0; // minutes per km
  double _averagePace = 0; // minutes per km
  int _calories = 0; // estimated calories burned
  double _elevationGain = 0; // in meters

  // For auto-following current position
  bool _isFollowingPosition = true;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initCompass();

    // If predefined route mode, set up the route
    if (widget.runMode == RunMode.predefinedRoute &&
        widget.predefinedRoute != null) {
      _routePoints = List.from(widget.predefinedRoute!.coordinates);
      // Extract directions from the predefined route
      _extractDirectionsFromRoute(_routePoints);
    }

    // Get current position as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentPosition().then((_) {
        if (_currentPosition != null) {
          // Ensure the map is centered on current position
          _mapController.move(_currentPosition!, 15);
        }
      });
    });
  }

  void _initCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission permanently denied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permissions are permanently denied.')),
        );
      }
      return;
    }

    // Permission granted, get current position
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _lastRecordedPosition = position;

          // If this is first position, center map
          if (_mapController.zoom == 1) {
            _mapController.move(_currentPosition!, 15);
          }

          // If following mode is on, center map on current position
          if (_isFollowingPosition && _isTracking) {
            _mapController.move(_currentPosition!, _mapController.zoom);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  void _extractDirectionsFromRoute(List<LatLng> routePoints) {
    if (routePoints.length < 2) return;

    List<Map<String, dynamic>> directions = [];

    // Create simple directions from route points (simplified version)
    for (int i = 1; i < routePoints.length; i++) {
      LatLng prev = routePoints[i - 1];
      LatLng current = routePoints[i];

      // Calculate bearing between points
      double bearing = _calculateBearing(prev, current);
      String direction = _getDirectionFromBearing(bearing);

      // Calculate distance
      double distance = Geolocator.distanceBetween(
          prev.latitude, prev.longitude, current.latitude, current.longitude);

      directions.add({
        'instruction': "Continue $direction",
        'distance': distance,
        'location': prev,
        'type': 'turn',
        'modifier': direction.toLowerCase(),
      });
    }

    // Add final destination
    directions.add({
      'instruction': "You've reached your destination",
      'distance': 0,
      'location': routePoints.last,
      'type': 'arrive',
      'modifier': null,
    });

    setState(() {
      _directions = directions;
      _currentDirectionIndex = 0;
      _updateNextDirection();
      _updateDirectionMarkers();
    });
  }

  String _getDirectionFromBearing(double bearing) {
    // Normalize bearing to 0-360
    bearing = (bearing + 360) % 360;

    if (bearing > 337.5 || bearing <= 22.5) return "north";
    if (bearing > 22.5 && bearing <= 67.5) return "northeast";
    if (bearing > 67.5 && bearing <= 112.5) return "east";
    if (bearing > 112.5 && bearing <= 157.5) return "southeast";
    if (bearing > 157.5 && bearing <= 202.5) return "south";
    if (bearing > 202.5 && bearing <= 247.5) return "southwest";
    if (bearing > 247.5 && bearing <= 292.5) return "west";
    return "northwest";
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double startLat = start.latitude * math.pi / 180;
    double startLng = start.longitude * math.pi / 180;
    double endLat = end.latitude * math.pi / 180;
    double endLng = end.longitude * math.pi / 180;

    double dLng = endLng - startLng;

    double y = math.sin(dLng) * math.cos(endLat);
    double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(dLng);

    double bearing = math.atan2(y, x) * 180 / math.pi;
    return bearing;
  }

  Future<void> _getRouteDirections() async {
    if (_currentPosition == null || _destinationPosition == null) {
      return;
    }

    try {
      // Replace with your OSRM server or other routing API
      final response = await http.get(Uri.parse(
          'https://router.project-osrm.org/route/v1/foot/'
          '${_currentPosition!.longitude},${_currentPosition!.latitude};'
          '${_destinationPosition!.longitude},${_destinationPosition!.latitude}'
          '?overview=full&steps=true&geometries=geojson'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];

        // Extract route geometry
        final geometry = route['geometry']['coordinates'];
        final List<LatLng> points = [];

        for (var point in geometry) {
          // OSRM returns [lng, lat] so we need to swap them
          points.add(LatLng(point[1], point[0]));
        }

        // Extract direction steps
        final legs = route['legs'][0];
        final steps = legs['steps'];
        final List<Map<String, dynamic>> directions = [];

        for (var step in steps) {
          directions.add({
            'instruction': step['maneuver']['instruction'] ??
                step['name'] ??
                "Continue straight",
            'distance': step['distance'],
            'location': LatLng(step['maneuver']['location'][1],
                step['maneuver']['location'][0]),
            'type': step['maneuver']['type'],
            'modifier': step['maneuver']['modifier'],
          });
        }

        setState(() {
          _routePoints = points;
          _directions = directions;
          _currentDirectionIndex = 0;
          _updateNextDirection();
          _updateDirectionMarkers();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting directions: $e')),
        );
      }
    }
  }

  void _updateNextDirection() {
    if (_directions.isEmpty || _currentDirectionIndex >= _directions.length) {
      _nextDirection = "You've reached your destination!";
      return;
    }

    final nextStep = _directions[_currentDirectionIndex];
    final distance = (nextStep['distance'] as num).toInt();

    setState(() {
      _nextDirection = "${nextStep['instruction']} (${distance}m)";
    });
  }

  void _updateDirectionMarkers() {
    if (_directions.isEmpty || _currentDirectionIndex >= _directions.length) {
      setState(() {
        _directionMarkers = [];
      });
      return;
    }

    List<Marker> markers = [];

    // Add marker for the next direction point
    final nextStep = _directions[_currentDirectionIndex];
    LatLng markerPos = nextStep['location'];

    markers.add(
      Marker(
        point: markerPos,
        width: 40,
        height: 40,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getDirectionIcon(nextStep['type'], nextStep['modifier']),
            color: Colors.white,
          ),
        ),
      ),
    );

    setState(() {
      _directionMarkers = markers;
    });
  }

  IconData _getDirectionIcon(String type, String? modifier) {
    if (type == 'arrive') {
      return Icons.place;
    } else if (type == 'depart') {
      return Icons.my_location;
    } else if (type == 'turn') {
      if (modifier == 'left') {
        return Icons.turn_left;
      } else if (modifier == 'right') {
        return Icons.turn_right;
      } else if (modifier == 'sharp left') {
        return Icons.turn_sharp_left;
      } else if (modifier == 'sharp right') {
        return Icons.turn_sharp_right;
      } else if (modifier == 'slight left') {
        return Icons.turn_slight_left;
      } else if (modifier == 'slight right') {
        return Icons.turn_slight_right;
      }
    } else if (type == 'roundabout') {
      return Icons.roundabout_left;
    }

    return Icons.straight;
  }

  void _startTracking() {
    // For free run mode with no destination, just track the user's movement
    // without requiring a destination
    if (widget.runMode == RunMode.freeRun && _destinationPosition == null) {
      // That's okay - we'll just track the user's path without a destination
      setState(() {
        _nextDirection = "Free run mode - recording your path";
      });
    }

    // Initialize stats
    _startTime = DateTime.now();
    _distanceTraveled = 0;
    _splits = [];
    _currentSpeed = 0;
    _averageSpeed = 0;
    _currentPace = 0;
    _averagePace = 0;
    _calories = 0;
    _elevationGain = 0;

    setState(() {
      _isTracking = true;
      if (_currentPosition != null) {
        _trackedPath = [_currentPosition!];
      } else {
        _trackedPath = [];
      }
    });

    // Start tracking timer (update every 2 seconds)
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_currentPosition != null && _lastRecordedPosition != null) {
        // Calculate distance from last position
        final newPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final newLatLng = LatLng(newPosition.latitude, newPosition.longitude);

        final newDistance = Geolocator.distanceBetween(
            _lastRecordedPosition!.latitude,
            _lastRecordedPosition!.longitude,
            newPosition.latitude,
            newPosition.longitude);

        // Only count movement if it's significant (avoid GPS jitter)
        if (newDistance > 1.0) {
          setState(() {
            _currentPosition = newLatLng;
            _trackedPath.add(newLatLng);
            _distanceTraveled += newDistance;

            // Calculate elevation gain if available from Geolocator position
            if (newPosition.altitude > _lastRecordedPosition!.altitude) {
              _elevationGain +=
                  newPosition.altitude - _lastRecordedPosition!.altitude;
            }

            // Calculate current speed (m/s)
            _currentSpeed = newDistance / 2; // 2 seconds between updates

            // Calculate average speed
            final runDuration =
                DateTime.now().difference(_startTime!).inSeconds;
            if (runDuration > 0) {
              _averageSpeed = _distanceTraveled / runDuration;
            }

            // Calculate pace (min/km)
            if (_currentSpeed > 0) {
              _currentPace = (1000 / _currentSpeed) / 60; // Convert to min/km
            }

            if (_averageSpeed > 0) {
              _averagePace = (1000 / _averageSpeed) / 60; // Convert to min/km
            }

            // Calculate calories (very basic estimation)
            // Assumption: 1 calorie per kg per km for running
            final weight = 70; // Default weight in kg
            _calories = (weight * (_distanceTraveled / 1000)).round();

            // Handle splits (every km)
            final lastKm = (_distanceTraveled - newDistance) ~/ 1000;
            final currentKm = _distanceTraveled ~/ 1000;

            if (currentKm > lastKm) {
              // We've completed a new kilometer
              final splitDuration = DateTime.now().difference(_startTime!);
              final splitPace = _averagePace; // Current average pace

              _splits.add(SplitRun(
                distance: currentKm.toDouble(),
                duration: splitDuration,
                pace: splitPace,
              ));
            }

            // Update last position reference
            _lastRecordedPosition = newPosition;
          });

          // If following is enabled, center map on current position
          if (_isFollowingPosition) {
            _mapController.move(_currentPosition!, _mapController.zoom);
          }
        }

        // Check if we're near the next direction point
        if (_directions.isNotEmpty &&
            _currentDirectionIndex < _directions.length) {
          final nextPoint =
              _directions[_currentDirectionIndex]['location'] as LatLng;

          // Distance in meters to the next direction point
          final distanceToNext = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              nextPoint.latitude,
              nextPoint.longitude);

          // If within 20 meters of the next direction point, move to the next
          if (distanceToNext < 20 &&
              _currentDirectionIndex < _directions.length - 1) {
            setState(() {
              _currentDirectionIndex++;
              _updateNextDirection();
              _updateDirectionMarkers();
            });
          }

          // Check if we've reached the final destination
          if (_currentDirectionIndex == _directions.length - 1) {
            final destination = _directions.last['location'] as LatLng;
            final distanceToDestination = Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                destination.latitude,
                destination.longitude);

            if (distanceToDestination < 20) {
              _stopTracking();
              setState(() {
                _nextDirection = "You've reached your destination!";
              });

              // Show run summary
              _showRunSummary();
            }
          }
        }
      }
    });
  }

  void _stopTracking() {
    _timer?.cancel();
    _endTime = DateTime.now();
    setState(() {
      _isTracking = false;
    });

    // Show run summary
    _showRunSummary();
  }

  void _showRunSummary() {
    if (_startTime == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunSummaryScreen(
          trackedPath: _trackedPath,
          startTime: _startTime!,
          endTime: _endTime ?? DateTime.now(),
          distance: _distanceTraveled,
          splits: _splits,
          avgPace: _averagePace,
          calories: _calories,
          elevationGain: _elevationGain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.runMode == RunMode.freeRun
            ? 'Free Run'
            : widget.predefinedRoute?.name ?? 'Predefined Route'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                _isFollowingPosition ? Icons.gps_fixed : Icons.gps_not_fixed),
            onPressed: () {
              setState(() {
                _isFollowingPosition = !_isFollowingPosition;
                if (_isFollowingPosition && _currentPosition != null) {
                  _mapController.move(_currentPosition!, _mapController.zoom);
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition ?? const LatLng(0, 0),
              zoom: 14,
              onTap: (_, latLng) {
                if (!_isTracking && widget.runMode == RunMode.freeRun) {
                  setState(() {
                    _destinationPosition = latLng;
                  });
                  _getRouteDirections();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.run_tracker',
              ),
              // Planned route polyline
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue.withOpacity(0.7),
                    strokeWidth: 4.0,
                  ),
                ],
              ),
              // Tracked path polyline
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _trackedPath,
                    color: Colors.red.withOpacity(0.7),
                    strokeWidth: 5.0,
                  ),
                ],
              ),
              // Current position marker
              MarkerLayer(
                markers: [
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 40,
                      height: 40,
                      builder: (context) => Transform.rotate(
                        angle: _heading * (math.pi / 180),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  if (_destinationPosition != null)
                    Marker(
                      point: _destinationPosition!,
                      width: 40,
                      height: 40,
                      builder: (context) => const Icon(
                        Icons.flag,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                ],
              ),
              // Direction markers
              MarkerLayer(markers: _directionMarkers),
            ],
          ),
          // Stats Panel
          if (_isTracking)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Next direction
                    Text(
                      _nextDirection,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          'DISTANCE',
                          '${(_distanceTraveled / 1000).toStringAsFixed(2)} km',
                        ),
                        _buildStatColumn(
                          'PACE',
                          '${_averagePace.toStringAsFixed(2)} min/km',
                        ),
                        _buildStatColumn(
                          'TIME',
                          _formatDuration(
                            DateTime.now().difference(_startTime!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Instructions before starting
          if (!_isTracking)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  widget.runMode == RunMode.freeRun
                      ? "Tap anywhere on the map to set your destination, or just press START to record a free run"
                      : "Press START to begin following the route",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Recenter button
          FloatingActionButton(
            onPressed: () {
              if (_currentPosition != null) {
                _mapController.move(_currentPosition!, _mapController.zoom);
              }
            },
            heroTag: 'recenter',
            mini: true,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          // Start/Stop tracking button
          FloatingActionButton.extended(
            onPressed: _isTracking ? _stopTracking : _startTracking,
            heroTag: 'tracking',
            backgroundColor: _isTracking ? Colors.red : Colors.green,
            label: Text(_isTracking ? 'STOP' : 'START'),
            icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return hours == '00' ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }
}
