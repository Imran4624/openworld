import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Future<Map<String, double>?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logError('LocationService: Location services are disabled');
        return null;
      }

      PermissionStatus permissionStatus = await Permission.location.status;
      
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.location.request();
        if (permissionStatus.isDenied) {
          logError('LocationService: Location permission denied');
          return null;
        }
      }

      if (permissionStatus.isPermanentlyDenied) {
        logError('LocationService: Location permission permanently denied');
        return null;
      }

      LocationPermission geoPermission = await Geolocator.checkPermission();
      if (geoPermission == LocationPermission.denied) {
        geoPermission = await Geolocator.requestPermission();
        if (geoPermission == LocationPermission.denied) {
          return null;
        }
      }

      if (geoPermission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      logError('LocationService: Error getting current location: $e');
      return null;
    }
  }

  static Future<String?> getAddressFromAzureMaps(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://atlas.microsoft.com/search/address/reverse/json'
          '?api-version=1.0'
          '&query=$lat,$lng'
          '&subscription-key=${Config.AZURE_MAPS_API_KEY}'
          '&language=en-US',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['addresses'] != null && data['addresses'].isNotEmpty) {
          final address = data['addresses'][0]['address'];
          logInfo('Address Info from Azure: $address');
          return _formatAzureAddress(address);
        }
      }
      return null;
    } catch (e) {
      logError("Azure Maps Error: $e");
      return null;
    }
  }

  static String _formatAzureAddress(Map<String, dynamic> address) {
    return address['municipalitySubdivision'] ??
        address['municipality'] ??
        address['localName'] ??
        '';
  }

  static Future<Map<String, dynamic>?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url =
          Uri.parse('https://atlas.microsoft.com/search/address/reverse/json'
              '?api-version=1.0'
              '&query=$latitude,$longitude'
              '&subscription-key=${Config.AZURE_MAPS_API_KEY}'
              '&language=en-US');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logInfo('adrress data $data');
        if (data['addresses'] != null && data['addresses'].isNotEmpty) {
          final address = data['addresses'][0];
          final addressData = address['address'];

          String locationName = '';

          if (addressData['municipality'] != null) {
            locationName = addressData['municipality'];
          } else if (addressData['streetName'] != null) {
            locationName = addressData['streetName'];
            if (addressData['streetNumber'] != null) {
              locationName = '${addressData['streetNumber']} $locationName';
            }
          } else if (addressData['countrySecondarySubdivision'] != null) {
            locationName = addressData['countrySecondarySubdivision'];
          } else if (addressData['countrySubdivision'] != null) {
            locationName = addressData['countrySubdivision'];
          } else if (addressData['country'] != null) {
            locationName = addressData['country'];
          }

          if (locationName.isEmpty) {
            locationName = address['address']['freeformAddress'];
          }

          return {
            'name': locationName,
            'fullAddress': address['address']['freeformAddress'],
            'streetName': address['address']['streetName'],
            'streetNumber': address['address']['streetNumber'],
            'city': address['address']['municipality'],
            'state': address['address']['countrySubdivision'],
            'country': address['address']['country'],
            'postalCode': address['address']['extendedPostalCode'],
            'latitude': latitude,
            'longitude': longitude,
          };
        }
      }

      return null;
    } catch (e) {
      logError(' LocationService: Error getting address from coordinates: $e');
      return null;
    }
  }

  static Future<String?> getCurrentLocationAndAddress() async {
    try {
      final location = await getCurrentLocation();
      if (location == null) {
        return null;
      }

      final address = await getAddressFromAzureMaps(
        location['latitude']!,
        location['longitude']!,
      );

      if (address != null) {
        logInfo(
            ' LocationService: Successfully retrieved location data - City: $address');
        return address;
      }

      return null;
    } catch (e) {
      logError(
          ' LocationService: Error getting current location and address: $e');
      return null;
    }
  }

  static Future<List<LocationSuggestion>> searchNearbyPlaces(
    String query, {
    double? lat,
    double? lon,
    int limit = 5,
  }) async {
    try {
      
      if (query.trim().isEmpty && lat != null && lon != null) {
        return _searchNearbyPOI(lat, lon, limit);
      }
      
      if (query.trim().isEmpty) {
        return [];
      }
      
      String searchUrl = 'https://atlas.microsoft.com/search/fuzzy/json'
          '?api-version=1.0'
          '&typeahead=true'
          '&query=${Uri.encodeComponent(query.trim())}'
          '&limit=$limit'
          '&subscription-key=${Config.AZURE_MAPS_API_KEY}'
          '&language=en-US';

      if (lat != null && lon != null) {
        searchUrl += '&lat=$lat&lon=$lon';
      }

      final response = await http.get(Uri.parse(searchUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>? ?? [];

        final suggestions = results.map((result) {
          final address = result['address'];
          final position = result['position'];

          return LocationSuggestion(
            name: result['poi']?['name'] ??
                address['freeformAddress'] ??
                'Unknown',
            fullAddress: address['freeformAddress'] ?? '',
            city: address['municipality'] ?? '',
            state: address['countrySubdivision'] ?? '',
            country: address['country'] ?? '',
            postalCode: address['postalCode'] ?? address['extendedPostalCode'] ?? '',
            latitude: position?['lat']?.toDouble(),
            longitude: position?['lon']?.toDouble(),
          );
        }).toList();
        
        return suggestions;
      }

      return [];
    } catch (e) {
      logError('LocationService: Error searching nearby places: $e');
      return [];
    }
  }

  static Future<List<LocationSuggestion>> _searchNearbyPOI(
    double lat,
    double lon,
    int limit,
  ) async {
    try {
      final String searchUrl = 'https://atlas.microsoft.com/search/nearby/json'
          '?api-version=1.0'
          '&lat=$lat'
          '&lon=$lon'
          '&radius=5000'
          '&limit=$limit'
          '&subscription-key=${Config.AZURE_MAPS_API_KEY}'
          '&language=en-US';

      final response = await http.get(Uri.parse(searchUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>? ?? [];

        final suggestions = results.map((result) {
          final address = result['address'];
          final position = result['position'];

          return LocationSuggestion(
            name: result['poi']?['name'] ??
                address['freeformAddress'] ??
                'Nearby Location',
            fullAddress: address['freeformAddress'] ?? '',
            city: address['municipality'] ?? '',
            state: address['countrySubdivision'] ?? '',
            country: address['country'] ?? '',
            postalCode: address['postalCode'] ?? address['extendedPostalCode'] ?? '',
            latitude: position?['lat']?.toDouble(),
            longitude: position?['lon']?.toDouble(),
          );
        }).toList();
        
        return suggestions;
      }

      return [];
    } catch (e) {
      logError('LocationService: Error searching nearby POI: $e');
      return [];
    }
  }

  static Future<List<LocationSuggestion>> getNearbyAreaSuggestions(
    String query,
  ) async {
    try {
      if (query.trim().isEmpty) {
        final currentLocation = await getCurrentLocation();
        if (currentLocation != null) {
          return await _searchNearbyPOI(
            currentLocation['latitude']!,
            currentLocation['longitude']!,
            8,
          );
        }
        return [];
      } else {
        final results = await searchNearbyPlaces(
          query.trim(),
          limit: 8,
        );
        return results;
      }
    } catch (e) {
      logError(' LocationService: Error getting nearby area suggestions: $e');
      return [];
    }
  }
}

class LocationSuggestion {
  final String name;
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double? latitude;
  final double? longitude;

  LocationSuggestion({
    required this.name,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
  });

  String get displayName {
    if (name.isNotEmpty && name != fullAddress) {
      return name;
    }
    return fullAddress;
  }

  String get subtitle {
    final parts = <String>[];
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(', ');
  }

  @override
  String toString() => 'LocationSuggestion(name: $name, fullAddress: $fullAddress, city: $city, state: $state, country: $country, postalCode: $postalCode, lat: $latitude, lng: $longitude)';
}
