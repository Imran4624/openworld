import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'routes_data.dart';
import 'running_tracker_screen.dart';

class PredefinedRoutesScreen extends StatelessWidget {
  const PredefinedRoutesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get routes from repository
    final routes = RoutesRepository().getAllRoutes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Predefined Routes'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutePreviewScreen(route: route),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      route.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRouteDetail(
                            Icons.straighten, '${route.distance} km'),
                        _buildRouteDetail(Icons.timer, route.estDuration),
                        _buildRouteDetail(
                          Icons.trending_up,
                          route.difficulty,
                          _getDifficultyColor(route.difficulty),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteDetail(IconData icon, String text, [Color? color]) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.blueAccent,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color ?? Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blueAccent;
    }
  }
}

class RoutePreviewScreen extends StatelessWidget {
  final PredefinedRoute route;

  const RoutePreviewScreen({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _getRouteCenter(route.coordinates),
                zoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.run_tracker',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route.coordinates,
                      color: Colors.blue.withOpacity(0.7),
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    // Start marker
                    Marker(
                      point: route.coordinates.first,
                      width: 40,
                      height: 40,
                      builder: (context) => const Icon(
                        Icons.play_circle_fill,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    // End marker
                    Marker(
                      point: route.coordinates.last,
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
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  route.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRouteStatCard(
                      'Distance',
                      '${route.distance} km',
                      Icons.straighten,
                    ),
                    _buildRouteStatCard(
                      'Duration',
                      route.estDuration,
                      Icons.timer,
                    ),
                    _buildRouteStatCard(
                      'Difficulty',
                      route.difficulty,
                      Icons.trending_up,
                      _getDifficultyColor(route.difficulty),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunningTrackerScreen(
                            runMode: RunMode.predefinedRoute,
                            predefinedRoute: route,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'START THIS ROUTE',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStatCard(String label, String value, IconData icon,
      [Color? iconColor]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: iconColor ?? Colors.blueAccent,
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
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  LatLng _getRouteCenter(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return const LatLng(0, 0);
    }

    double sumLat = 0;
    double sumLng = 0;

    for (var point in coordinates) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    return LatLng(
      sumLat / coordinates.length,
      sumLng / coordinates.length,
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blueAccent;
    }
  }
}
