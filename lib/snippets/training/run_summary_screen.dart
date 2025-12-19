import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'routes_data.dart';

class RunSummaryScreen extends StatelessWidget {
  final List<LatLng> trackedPath;
  final DateTime startTime;
  final DateTime endTime;
  final double distance; // in meters
  final List<SplitRun> splits;
  final double avgPace; // min/km
  final int calories;
  final double elevationGain; // in meters

  const RunSummaryScreen({
    Key? key,
    required this.trackedPath,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.splits,
    required this.avgPace,
    required this.calories,
    required this.elevationGain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate bounds to fit all points on map
    final bounds = _calculateMapBounds();
    final duration = endTime.difference(startTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Summary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Sharing functionality would be implemented here')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map with tracked path
            AspectRatio(
              aspectRatio: 1.0,
              child: FlutterMap(
                options: MapOptions(
                  bounds: bounds,
                  boundsOptions:
                      const FitBoundsOptions(padding: EdgeInsets.all(30)),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.run_tracker',
                  ),
                  // Tracked path polyline
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: trackedPath,
                        color: Colors.red.withOpacity(0.7),
                        strokeWidth: 5.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      // Start marker
                      if (trackedPath.isNotEmpty)
                        Marker(
                          point: trackedPath.first,
                          width: 40,
                          height: 40,
                          builder: (context) => const Icon(
                            Icons.play_circle_fill,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                      // End marker
                      if (trackedPath.isNotEmpty)
                        Marker(
                          point: trackedPath.last,
                          width: 40,
                          height: 40,
                          builder: (context) => const Icon(
                            Icons.flag,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Summary stats cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RUN SUMMARY',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('EEEE, MMMM d, yyyy').format(startTime)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Time: ${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                            'Distance',
                            '${(distance / 1000).toStringAsFixed(2)} km',
                            Icons.straighten),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                            'Duration', _formatDuration(duration), Icons.timer),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                            'Avg. Pace',
                            '${avgPace.toStringAsFixed(2)} min/km',
                            Icons.speed),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Calories', '$calories kcal',
                            Icons.local_fire_department),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                            'Elevation',
                            '${elevationGain.toStringAsFixed(1)} m',
                            Icons.trending_up),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                            'Avg. Speed',
                            '${(distance / duration.inSeconds).toStringAsFixed(1)} m/s',
                            Icons.directions_run),
                      ),
                    ],
                  ),

                  // Splits section
                  if (splits.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    const Text(
                      'SPLITS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: splits.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        itemBuilder: (context, index) {
                          final split = splits[index];
                          final isLastSplit = index == splits.length - 1;
                          final splitNumber = index + 1;
                          final prevSplitDuration = index > 0
                              ? splits[index - 1].duration
                              : Duration.zero;
                          final splitTime = split.duration - prevSplitDuration;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'KM $splitNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatDuration(splitTime),
                                  style: TextStyle(
                                    fontWeight: isLastSplit
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        isLastSplit ? Colors.blueAccent : null,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  '${split.pace.toStringAsFixed(2)} min/km',
                                  style: TextStyle(
                                    fontWeight: isLastSplit
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        isLastSplit ? Colors.blueAccent : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                  // Save and share buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Run saved to history')),
                            );

                            // Navigate back to home screen
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('SAVE TO HISTORY'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LatLngBounds _calculateMapBounds() {
    if (trackedPath.isEmpty) {
      return LatLngBounds(
        const LatLng(0, 0),
        const LatLng(0, 0),
      );
    }

    double minLat = trackedPath.first.latitude;
    double maxLat = trackedPath.first.latitude;
    double minLng = trackedPath.first.longitude;
    double maxLng = trackedPath.first.longitude;

    for (final point in trackedPath) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
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
