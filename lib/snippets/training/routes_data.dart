import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// Centralized repository of predefined routes
class RoutesRepository {
  // Singleton pattern
  static final RoutesRepository _instance = RoutesRepository._internal();

  factory RoutesRepository() {
    return _instance;
  }

  RoutesRepository._internal();

  // List of predefined routes
  final List<PredefinedRoute> predefinedRoutes = [
    PredefinedRoute(
      id: '1',
      name: 'City Park 5K',
      description: 'A scenic 5K route through the city park.',
      distance: 5.0,
      estDuration: '25-30 min',
      difficulty: 'Easy',
      coordinates: [
        const LatLng(51.47309, 0.01158),
        const LatLng(51.47325, 0.01284),
        const LatLng(51.47412, 0.01525),
        const LatLng(51.47528, 0.01693),
        const LatLng(51.47635, 0.01784),
        const LatLng(51.47702, 0.01692),
        const LatLng(51.47756, 0.01529),
        const LatLng(51.47732, 0.01357),
        const LatLng(51.47667, 0.01230),
        const LatLng(51.47569, 0.01135),
        const LatLng(51.47461, 0.01069),
        const LatLng(51.47309, 0.01158),
      ],
    ),
    PredefinedRoute(
      id: '2',
      name: 'Riverside Trail 10K',
      description: 'Beautiful trail along the river with great views.',
      distance: 10.0,
      estDuration: '50-60 min',
      difficulty: 'Moderate',
      coordinates: [
        const LatLng(51.48309, 0.02158),
        const LatLng(51.48425, 0.02384),
        const LatLng(51.48512, 0.02625),
        const LatLng(51.48628, 0.02793),
        const LatLng(51.48735, 0.02884),
        const LatLng(51.48802, 0.02792),
        const LatLng(51.48856, 0.02629),
        const LatLng(51.48832, 0.02457),
        const LatLng(51.48767, 0.02330),
        const LatLng(51.48669, 0.02235),
        const LatLng(51.48561, 0.02169),
        const LatLng(51.48309, 0.02158),
      ],
    ),
    PredefinedRoute(
      id: '3',
      name: 'Mountain Half Marathon',
      description: 'Challenging half marathon with elevation gain.',
      distance: 21.1,
      estDuration: '1h 45min - 2h 15min',
      difficulty: 'Hard',
      coordinates: [
        const LatLng(51.49309, 0.03158),
        const LatLng(51.49425, 0.03384),
        const LatLng(51.49512, 0.03625),
        const LatLng(51.49628, 0.03793),
        const LatLng(51.49735, 0.03884),
        const LatLng(51.49802, 0.03792),
        const LatLng(51.49856, 0.03629),
        const LatLng(51.49832, 0.03457),
        const LatLng(51.49767, 0.03330),
        const LatLng(51.49669, 0.03235),
        const LatLng(51.49561, 0.03169),
        const LatLng(51.49309, 0.03158),
      ],
    ),
  ];

  // Get a route by ID
  PredefinedRoute? getRouteById(String id) {
    try {
      return predefinedRoutes.firstWhere((route) => route.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all routes
  List<PredefinedRoute> getAllRoutes() {
    return predefinedRoutes;
  }

  // Get routes by difficulty
  List<PredefinedRoute> getRoutesByDifficulty(String difficulty) {
    return predefinedRoutes
        .where((route) =>
            route.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }
}

// Model class for predefined route
class PredefinedRoute {
  final String id;
  final String name;
  final String description;
  final double distance; // in km
  final String estDuration;
  final String difficulty;
  final List<LatLng> coordinates;

  const PredefinedRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.estDuration,
    required this.difficulty,
    required this.coordinates,
  });
}

// Model class for km splits
class SplitRun {
  final double distance; // in km
  final Duration duration; // cumulative time at this split
  final double pace; // min/km for this split

  const SplitRun({
    required this.distance,
    required this.duration,
    required this.pace,
  });
}
