import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/workout_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ActiveRunScreen extends StatefulWidget {
  final int? totalSeconds;
  final double? distanceCovered;
  final double? currentPace;
  final int? currentSegmentIndex;
  final String? currentActivity;
  final bool? isPaused;
  final bool? isCompleted;
  final List<LatLng>? trackPoints;
  final LatLng? startPosition;
  final LatLng? currentPosition;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onEnd;
  final bool showControls;

  const ActiveRunScreen({
    super.key,
    this.totalSeconds,
    this.distanceCovered,
    this.currentPace,
    this.currentSegmentIndex,
    this.currentActivity,
    this.isPaused,
    this.isCompleted,
    this.trackPoints,
    this.startPosition,
    this.currentPosition,
    this.onPause,
    this.onResume,
    this.onEnd,
    this.showControls = true,
  });

  @override
  State<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

enum RunState { notStarted, running, paused, ended }

class _ActiveRunScreenState extends State<ActiveRunScreen> {
  final MapController mapController = MapController();
  bool locationPermissionGranted = false;

  RunState runState = RunState.notStarted;
  int totalSeconds = 0;
  double distanceCovered = 0.0;
  double currentPace = 0.0;
  LatLng? startPosition;
  LatLng? currentPosition;
  List<LatLng> trackPoints = [];
  Timer? timer;
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    if (!_isFreeRunMode()) {
      totalSeconds = widget.totalSeconds ?? 0;
      distanceCovered = widget.distanceCovered ?? 0.0;
      currentPace = widget.currentPace ?? 0.0;
      startPosition = widget.startPosition;
      currentPosition = widget.currentPosition;
      trackPoints = widget.trackPoints ?? [];
    }
  }

  bool _isFreeRunMode() {
    return widget.totalSeconds == null && widget.trackPoints == null;
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      locationPermissionGranted = status.isGranted;
    });
    if (status.isGranted && _isFreeRunMode()) {
      _getCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      locationPermissionGranted = status.isGranted;
    });
    if (status.isGranted && _isFreeRunMode()) {
      _getCurrentLocation();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      LatLng latLng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        currentPosition = latLng;
        startPosition ??= latLng;
        if (trackPoints.isEmpty || trackPoints.last != latLng) {
          trackPoints.add(latLng);
        }
      });
    } catch (e) {
    }
  }

  void _startRun() {
    setState(() {
      runState = RunState.running;
      totalSeconds = 0;
      distanceCovered = 0.0;
      currentPace = 0.0;
      trackPoints = [];
      startPosition = currentPosition;
    });
    timer = Timer.periodic(const Duration(seconds: 1), _updateRunProgress);
    locationTimer = Timer.periodic(const Duration(seconds: 2), _updateLocation);
  }

  void _pauseRun() {
    setState(() {
      runState = RunState.paused;
    });
    timer?.cancel();
    locationTimer?.cancel();
  }

  void _resumeRun() {
    setState(() {
      runState = RunState.running;
    });
    timer = Timer.periodic(const Duration(seconds: 1), _updateRunProgress);
    locationTimer = Timer.periodic(const Duration(seconds: 2), _updateLocation);
  }

  void _endRun() {
    setState(() {
      runState = RunState.ended;
    });
    timer?.cancel();
    locationTimer?.cancel();
    _saveAndEditWorkout();
  }

  void _saveAndEditWorkout() {
    final store = StoreProvider.of<AppState>(context);
    final now = DateTime.now();
    final startTime = now.subtract(Duration(seconds: totalSeconds));
    final endTime = now;
    final distanceMeters = (distanceCovered * 1000).round();
    final pace = distanceCovered > 0 ? (totalSeconds / distanceCovered).round() : 0;
    final calories = 0; 
    final elevationGain = 0;
    final workoutEntity = WorkoutEntity().rebuild((b) => b
      ..type = 'Running'
      ..startTime = startTime.millisecondsSinceEpoch
      ..endTime = endTime.millisecondsSinceEpoch
      ..duration = totalSeconds
      ..distance = distanceMeters
      ..averagePace = pace
      ..caloriesBurned = calories
      ..elevationGain = elevationGain
      ..createdAt = now.millisecondsSinceEpoch
      ..updatedAt = now.millisecondsSinceEpoch
    );
    store.dispatch(EditWorkout(workout: workoutEntity));
  }

  void _updateRunProgress(Timer timer) {
    setState(() {
      totalSeconds++;
      if (trackPoints.length > 1) {
        double dist = 0.0;
        for (int i = 1; i < trackPoints.length; i++) {
          dist += const Distance().as(LengthUnit.Meter, trackPoints[i - 1], trackPoints[i]);
        }
        distanceCovered = dist / 1000.0; 
        currentPace = distanceCovered > 0 ? (totalSeconds / 60) / distanceCovered : 0.0;
      }
    });
  }

  void _updateLocation(Timer timer) async {
    if (!locationPermissionGranted || runState != RunState.running) return;
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      LatLng latLng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        currentPosition = latLng;
        if (trackPoints.isEmpty || trackPoints.last != latLng) {
          trackPoints.add(latLng);
        }
      });
    } catch (e) {
      printL("$e");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    locationTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatPace(double pace) {
    if (pace == 0 || pace.isInfinite || pace.isNaN) return '0:00';
    int minutes = pace.floor();
    int seconds = ((pace - minutes) * 60).round();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool freeRun = _isFreeRunMode();
    final bool showMap = currentPosition != null;
    final List<LatLng> polyline = trackPoints;
    final LatLng? mapCenter = currentPosition;
    final LatLng? mapStart = startPosition;
    final double distance = freeRun ? distanceCovered : (widget.distanceCovered ?? 0.0);
    final int seconds = freeRun ? totalSeconds : (widget.totalSeconds ?? 0);
    final double pace = freeRun ? currentPace : (widget.currentPace ?? 0.0);
    final bool showControls = freeRun;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          if (!locationPermissionGranted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.orange.withOpacity(0.9),
              child: Row(
                children: [
                  const Icon(Icons.location_off, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Location permission needed for accurate tracking',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: _requestLocationPermission,
                    child: const Text(
                      'ENABLE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                if (showMap && mapCenter != null)
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: mapCenter,
                      zoom: 16.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      if (polyline.length > 1)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: polyline,
                              strokeWidth: 4.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            if (mapStart != null)
                              Marker(
                                width: 20.0,
                                height: 20.0,
                                point: mapStart,
                                builder: (ctx) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          if (mapCenter != null)
                            Marker(
                              width: 20.0,
                              height: 20.0,
                              point: mapCenter,
                              builder: (ctx) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'CURRENT WORKOUT',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn(
                                distance.toStringAsFixed(2),
                                'KM',
                                'DISTANCE',
                              ),
                              _buildStatColumn(
                                _formatTime(seconds),
                                '',
                                'TIME',
                              ),
                              _buildStatColumn(
                                _formatPace(pace),
                                '',
                                'PACE',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showControls)
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Builder(
                      builder: (context) {
                        if (runState == RunState.notStarted) {
                          return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ready to Start?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ElevatedButton(
                            onPressed: locationPermissionGranted ? _startRun : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: CircleBorder(),
                              elevation: 8,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!locationPermissionGranted)
                          const Text(
                            'Enable location permission to start',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  );
                        } else if (runState == RunState.running || runState == RunState.paused) {
                          return Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: runState == RunState.running ? _pauseRun : _resumeRun,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: runState == RunState.running 
                                          ? Colors.orange 
                                          : Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          runState == RunState.running 
                                              ? Icons.pause 
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          runState == RunState.running ? 'PAUSE' : 'RESUME',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _endRun,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.stop, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'END',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String unit, String label) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}