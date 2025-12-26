// Flutter imports:
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart' as appView;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/services/location_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

enum ViewMode { map, list }

enum ViewType { list, grid, gridImproved }

enum ListTab { happeningNow, topEvents, pickedForYou }

enum ChatMessageType { user, ai, system }

class ChatMessage {
  final String id;
  final String content;
  final ChatMessageType type;
  final DateTime timestamp;
  final List<EventEntity>? events;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.events,
    this.isLoading = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    ChatMessageType? type,
    DateTime? timestamp,
    List<EventEntity>? events,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

Future<void> openMapWithLocation({
  required BuildContext context,
  required double latitude,
  required double longitude,
  String? locationName,
}) async {
  final String query = locationName != null
      ? Uri.encodeComponent(locationName)
      : '$latitude,$longitude';

  String mapUrl;

  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    mapUrl = 'https://www.google.com/maps/search/?api=1&query=$query';
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    mapUrl = 'http://maps.apple.com/?q=$query';
  } else {
    mapUrl = 'geo:$latitude,$longitude?q=$latitude,$longitude($query)';
  }

  appView.openUrl(context, mapUrl, 'Open in Maps');
}

class EntityListOpw extends StatefulWidget {
  const EntityListOpw({
    Key? key,
    required this.state,
    required this.entityList,
    required this.onRefreshed,
    required this.onEventTap,
  }) : super(key: key);

  final AppState state;
  final List<String?> entityList;
  final Function(BuildContext) onRefreshed;
  final Function(EventEntity) onEventTap;

  @override
  _EntityListOpwState createState() => _EntityListOpwState();
}

class _EntityListOpwState extends State<EntityListOpw>
    with TickerProviderStateMixin {
  ViewMode _currentViewMode = ViewMode.map;
  bool _isViewModeLoaded = false;
  bool _isAiSearching = false;
  String? _selectedEventType;
  bool _showSavedEventView = true;
  ListTab _selectedListTab = ListTab.happeningNow;
  late ScrollController _scrollController;
  String _userLocation = ProjectConfig.defaultUserLocation;
  LocationSuggestion? _selectedLocation;
  List<LocationSuggestion> _nearbyLocations = [];
  bool _showLocationDropdown = false;
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  EventEntity? _selectedEvent;
  LatLng? _currentUserLocation;
  Map<String, double>? _mapBounds;

  late AnimationController _radarAnimationController;
  late Animation<double> _radarAnimation;

  bool _isLoadingLocation = false;
  bool _isLoadingNearbyLocations = false;
  bool _locationInitialized = false;
  Timer? _locationTimer;
  Timer? _markerCreationTimer;

  final List<ChatMessage> _chatMessages = [];
  bool _isChatOpen = false;
  double _currentZoomLevel = 12.0;

  static LatLng get _defaultLocation {
    final coords = ProjectConfig.defaultLocationCoordinates;
    return LatLng(coords['latitude']!, coords['longitude']!);
  }

  static const double _defaultZoom = 12.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && !_isChatOpen) {
        setState(() {
          _isChatOpen = true;
        });
      }
    });

    _radarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000), 
      vsync: this,
    );
    _radarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _radarAnimationController,
      curve: Curves.easeInOut,
    ));

    _radarAnimationController.repeat();

    _loadSavedViewMode();
    _getCurrentUserLocation();

    _createEventMarkers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showSavedEventView) {
        final store = StoreProvider.of<AppState>(context);
        store.dispatch(LoadEvents(isRefresh: true));
      } else {
        _performInitialAiSearch();
      }
    });
  }

  @override
  void didUpdateWidget(EntityListOpw oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entityList != oldWidget.entityList) {
      _createEventMarkers();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      _extractMapBoundsFromAiEvents();
    }
  }

  void _extractMapBoundsFromAiEvents() {
    final events = _getFilteredEvents();
    if (events.isNotEmpty &&
        events.any((e) => e.callToAction == CallToActionType.thirdParty)) {
      _calculateBoundsFromEvents(events);
    }
  }

  void _calculateBoundsFromEvents(List<EventEntity> events) {
    if (events.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;

    for (final event in events) {
      final location = _getEventLocation(event);
      if (location != null) {
        minLat = minLat == null
            ? location.latitude
            : math.min(minLat, location.latitude);
        maxLat = maxLat == null
            ? location.latitude
            : math.max(maxLat, location.latitude);
        minLng = minLng == null
            ? location.longitude
            : math.min(minLng, location.longitude);
        maxLng = maxLng == null
            ? location.longitude
            : math.max(maxLng, location.longitude);
      }
    }

    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      _mapBounds = {
        'min_lat': minLat,
        'max_lat': maxLat,
        'min_lng': minLng,
        'max_lng': maxLng,
      };
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _radarAnimationController.dispose();
    _locationTimer?.cancel();
    _markerCreationTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentUserLocation() async {
    if (_isLoadingLocation || _locationInitialized) {
      return;
    }

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        logError('_getCurrentUserLocation: Location services are disabled');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Location services are disabled. Enable them in your device settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        _setDefaultLocationAsCurrentLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          logError('_getCurrentUserLocation: Permission denied after request');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Location permission denied. Using default location.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          _setDefaultLocationAsCurrentLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        logError('_getCurrentUserLocation: Permission permanently denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Location permission is permanently denied. Enable it in app settings to use current location.'),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () async {
                  await openAppSettings();
                },
              ),
            ),
          );
        }
        _setDefaultLocationAsCurrentLocation();
        return;
      }

      final permissionStatus = await Permission.location.status;

      if (permissionStatus.isDenied) {
        final newPermissionStatus = await Permission.location.request();

        if (newPermissionStatus.isDenied) {
          logError(
              '_getCurrentUserLocation: Permission handler denied after request');
          _setDefaultLocationAsCurrentLocation();
          return;
        }
      }

      final location = await LocationService.getCurrentLocation();

      if (location != null && mounted) {
        final currentLocation = LatLng(
          location['latitude']!,
          location['longitude']!,
        );

        final locationName =
            await LocationService.getCurrentLocationAndAddress();

        if (mounted) {
          setState(() {
            _currentUserLocation = currentLocation;
            _userLocation = locationName ?? 'Current Location';
            _selectedLocation = LocationSuggestion(
              name: 'Current Location',
              fullAddress: locationName ?? 'Current Location',
              city: locationName ?? 'Current Location',
              state: '',
              country: '',
              postalCode: '',
              latitude: location['latitude']!,
              longitude: location['longitude']!,
            );
            _isLoadingLocation = false;
            _locationInitialized = true;
          });

          _locationTimer?.cancel();
          _locationTimer = Timer(const Duration(milliseconds: 300), () {
            if (mounted && _currentViewMode == ViewMode.map) {
              _mapController.move(currentLocation, _defaultZoom);
              setState(() {
                _currentZoomLevel = _defaultZoom;
              });
              _createEventMarkers();
            }
          });

          _loadNearbyLocations(locationName ?? 'Current Location');
        }
      } else {
        _setDefaultLocationAsCurrentLocation();
      }
    } catch (e) {
      logError('Error getting current user location: $e');
      _setDefaultLocationAsCurrentLocation();
    }
  }

  void _setDefaultLocationAsCurrentLocation() {
    if (!mounted) return;

    final defaultLocation = ProjectConfig.defaultUserLocation;
    final defaultLocationCoords = _defaultLocation;

    setState(() {
      _currentUserLocation = defaultLocationCoords;
      _userLocation = defaultLocation;
      _selectedLocation = LocationSuggestion(
        name: 'Current Location',
        fullAddress: defaultLocation,
        city: defaultLocation,
        state: '',
        country: 'United Kingdom',
        postalCode: '',
        latitude: defaultLocationCoords.latitude,
        longitude: defaultLocationCoords.longitude,
      );
      _isLoadingLocation = false;
      _locationInitialized = true;
    });

    _locationTimer?.cancel();
    _locationTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted && _currentViewMode == ViewMode.map) {
        _mapController.move(defaultLocationCoords, _defaultZoom);
        setState(() {
          _currentZoomLevel = _defaultZoom;
        });
        _createEventMarkers();
      }
    });

    _loadNearbyLocationsWithTimeout(defaultLocation);
  }

  Future<void> _loadNearbyLocationsWithTimeout(String locationName) async {
    if (_isLoadingNearbyLocations || _currentUserLocation == null) return;

    setState(() {
      _isLoadingNearbyLocations = true;
    });

    try {
      final locations = await LocationService.searchNearbyPlaces(
        locationName,
        lat: _currentUserLocation!.latitude,
        lon: _currentUserLocation!.longitude,
        limit: 10,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return <LocationSuggestion>[];
        },
      );

      if (mounted) {
        setState(() {
          _nearbyLocations = locations;
          _isLoadingNearbyLocations = false;
        });
      }
    } catch (e) {
      logError('Error loading nearby locations: $e');
      if (mounted) {
        setState(() {
          _nearbyLocations = [];
          _isLoadingNearbyLocations = false;
        });
      }
    }
  }

  Future<void> _loadNearbyLocations(String locationName) async {
    if (_isLoadingNearbyLocations || _currentUserLocation == null) return;

    setState(() {
      _isLoadingNearbyLocations = true;
    });

    try {
      final locations = await LocationService.searchNearbyPlaces(
        locationName,
        lat: _currentUserLocation!.latitude,
        lon: _currentUserLocation!.longitude,
        limit: 10,
      ).timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          return <LocationSuggestion>[];
        },
      );

      if (mounted) {
        setState(() {
          _nearbyLocations = locations;
          _isLoadingNearbyLocations = false;
        });
      }
    } catch (e) {
      logError('Error loading nearby locations: $e');
      if (mounted) {
        setState(() {
          _nearbyLocations = [];
          _isLoadingNearbyLocations = false;
        });
      }
    }
  }

  Future<void> _loadSavedViewMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedViewMode = prefs.getString('event_view_mode');

      if (mounted) {
        setState(() {
          if (savedViewMode != null) {
            if (savedViewMode == 'list') {
              _currentViewMode = ViewMode.list;
            } else {
              _currentViewMode = ViewMode.map;
            }
          }
          _isViewModeLoaded = true;
        });

        if (_currentViewMode == ViewMode.map) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _centerMapOnUserLocation();
          });
        }
      }
    } catch (e) {
      logError('Error loading saved view mode: $e');
      if (mounted) {
        setState(() {
          _isViewModeLoaded = true;
        });
      }
    }
  }

  // View mode saving method - currently unused as toggle buttons are hidden
  /*
  Future<void> _saveViewMode(ViewMode viewMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final viewModeString = viewMode == ViewMode.list ? 'list' : 'map';
      await prefs.setString('event_view_mode', viewModeString);
    } catch (e) {
      logError('Error saving view mode: $e');
    }
  }
  */

  void _addUserMessage(String content) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: ChatMessageType.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _chatMessages.add(message);
    });
  }

  void _addAIResponse(String content, {List<EventEntity>? events}) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: ChatMessageType.ai,
      timestamp: DateTime.now(),
      events: events,
    );

    setState(() {
      _chatMessages.add(message);
    });

    if (events != null && events.isNotEmpty) {
      _calculateBoundsFromEvents(events);
      _createEventMarkers();

      if (mounted && _currentViewMode == ViewMode.map) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _fitMapToBounds();
          }
        });
      }
    }
  }

  void _addLoadingMessage() {
    final message = ChatMessage(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      type: ChatMessageType.ai,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    setState(() {
      _chatMessages.add(message);
    });

    if (!_radarAnimationController.isAnimating) {
      _radarAnimationController.repeat();
    }
  }

  void _removeLoadingMessage() {
    setState(() {
      _chatMessages.removeWhere((message) => message.isLoading);
    });

    if (!_chatMessages.any((message) => message.isLoading)) {
      _radarAnimationController.stop();
    }
  }

  void _clearPreviousEventResponses() {
    setState(() {
      for (int i = 0; i < _chatMessages.length; i++) {
        final message = _chatMessages[i];
        if (message.type == ChatMessageType.ai &&
            message.events != null &&
            message.events!.isNotEmpty) {
          _chatMessages[i] = ChatMessage(
            id: message.id,
            content: message.content,
            type: ChatMessageType.ai,
            timestamp: message.timestamp,
            events: null,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeColors =
        AppTheme.getThemeColors(theme.brightness == Brightness.dark);

    if (!_isViewModeLoaded) {
      return Scaffold(
        backgroundColor: themeColors.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: themeColors.background,
      body: GestureDetector(
        onTap: () {
          if (_showLocationDropdown) {
            setState(() {
              _showLocationDropdown = false;
            });
          }
        },
        child: Stack(
          children: [
            _currentViewMode == ViewMode.map
                ? _buildMapFullScreenView(theme, themeColors)
                : _buildListViewWithHeader(theme, themeColors),
            if (_showLocationDropdown)
              _buildLocationDropdown(theme, themeColors),
            if (_isChatOpen) _buildChatBottomSheet(theme, themeColors),
          ],
        ),
      ),
    );
  }

  Widget _buildMapFullScreenView(ThemeData theme, ThemeColors themeColors) {
    return Stack(
      children: [
        _buildMapBackground(theme, themeColors),
        if (_showSavedEventView) _buildFloatingHeader(theme, themeColors),
        if (_showSavedEventView) _buildEventCards(theme, themeColors),
        _buildFloatingActionButtons(theme, themeColors),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomSection(theme, themeColors),
        ),
      ],
    );
  }

  Widget _buildListViewWithHeader(ThemeData theme, ThemeColors themeColors) {
    return Column(
      children: [
        _buildNormalHeader(theme, themeColors),
        Expanded(
          child: _buildListView(theme, themeColors),
        ),
        _buildBottomSection(theme, themeColors),
      ],
    );
  }

  Widget _buildFloatingHeader(ThemeData theme, ThemeColors themeColors) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Location',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[400],
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showLocationDropdown = !_showLocationDropdown;
                          });
                        },
                        child: Row(
                          children: [
                            if (_isLoadingLocation)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              Text(
                                _userLocation,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(width: 4),
                            Icon(
                              _showLocationDropdown
                                  ? CupertinoIcons.arrowtriangle_up_fill
                                  : CupertinoIcons.arrowtriangle_down_fill,
                              color: Colors.black87,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildProfilePicture(theme, themeColors),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Toggle buttons hidden - showing only map
                    // _buildToggleButton(
                    //     'Map', ViewMode.map, Icons.map, theme, themeColors),
                    // _buildToggleButton('List', ViewMode.list,
                    //     HugeIcons.strokeRoundedMenu01, theme, themeColors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalHeader(ThemeData theme, ThemeColors themeColors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: themeColors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Location',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showLocationDropdown = !_showLocationDropdown;
                    });
                  },
                  child: Row(
                    children: [
                      if (_isLoadingLocation)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Text(
                          _userLocation,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Icon(
                        _showLocationDropdown
                            ? CupertinoIcons.arrowtriangle_up_fill
                            : CupertinoIcons.arrowtriangle_down_fill,
                        color: Colors.black87,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle buttons hidden - showing only map
                // _buildToggleButton(
                //     'Map', ViewMode.map, Icons.map, theme, themeColors),
                // _buildToggleButton('List', ViewMode.list,
                //     HugeIcons.strokeRoundedMenu01, theme, themeColors),
              ],
            ),
          ),
          const Spacer(),
          _buildProfilePicture(theme, themeColors),
        ],
      ),
    );
  }

  // Toggle button method - currently unused as toggle buttons are hidden
  /*
  Widget _buildToggleButton(String text, ViewMode mode, IconData icon,
      ThemeData theme, ThemeColors themeColors) {
    final isSelected = _currentViewMode == mode;
    final showText = _currentViewMode == ViewMode.map;

    return GestureDetector(
      onTap: () {
        setState(() => _currentViewMode = mode);
        _saveViewMode(mode);
        if (mode == ViewMode.map) {
          _centerMapOnUserLocation();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.black : Colors.white60,
            ),
            if (showText) ...[
              const SizedBox(width: 10),
              Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.black : Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  */

  Widget _buildProfilePicture(ThemeData theme, ThemeColors themeColors) {
    final state = widget.state;
    String? thumbnailUrl;

    try {
      final dynamicFields =
          state.profileState.loggedInUserProfile.dynamicFields;
      if (dynamicFields.containsKey('images')) {
        final images = dynamicFields['images'];
        if (images is List && images.isNotEmpty) {
          final firstImage = images.first;
          if (firstImage is String) {
            thumbnailUrl = firstImage;
          } else if (firstImage is Map<String, dynamic> &&
              firstImage.containsKey('url')) {
            final urlValue = firstImage['url'];
            thumbnailUrl = urlValue is String ? urlValue : null;
          }
        }
      }
    } catch (e) {
      logError('Error getting profile image: $e');
      thumbnailUrl = null;
    }

    return GestureDetector(
      onTap: () {
        selectEntity(entity: state.profileState.loggedInUserProfile);
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: themeColors.primary,
        backgroundImage: thumbnailUrl?.isNotEmpty == true
            ? (thumbnailUrl!.startsWith('http')
                ? NetworkImage(thumbnailUrl)
                : AssetImage(thumbnailUrl)) as ImageProvider
            : const AssetImage('assets/opw/images/defaultUserThumbnail.jpg'),
      ),
    );
  }

  Widget _buildMapBackground(ThemeData theme, ThemeColors themeColors) {
    final allMarkers = <Marker>[];

    if (_currentUserLocation != null) {
      final userLocationMarker = Marker(
        point: _currentUserLocation!,
        width: 100,
        height: 100,
        builder: (context) => AnimatedBuilder(
          animation: _radarAnimation,
          builder: (context, child) {
            return SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40 + (60 * _radarAnimation.value),
                    height: 40 + (60 * _radarAnimation.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black
                            .withOpacity(0.6 * (1 - _radarAnimation.value)),
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 25 + (35 * _radarAnimation.value),
                    height: 25 + (35 * _radarAnimation.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black
                            .withOpacity(0.4 * (1 - _radarAnimation.value)),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedLocationUser03,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
      allMarkers.add(userLocationMarker);
    }

    allMarkers.addAll(_markers);

    LatLng mapCenter = _defaultLocation;
    if (_selectedLocation != null &&
        _selectedLocation!.latitude != null &&
        _selectedLocation!.longitude != null) {
      mapCenter =
          LatLng(_selectedLocation!.latitude!, _selectedLocation!.longitude!);
    } else if (_currentUserLocation != null) {
      mapCenter = _currentUserLocation!;
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: mapCenter,
            zoom: _defaultZoom,
            minZoom: 3.0,
            maxZoom: 18.0,
            onPositionChanged: (MapPosition position, bool hasGesture) {
              if (hasGesture &&
                  position.zoom != null &&
                  position.zoom != _currentZoomLevel) {
                final newZoom = position.zoom!;

                if ((newZoom - _currentZoomLevel).abs() >= 1.0) {
                  setState(() {
                    _currentZoomLevel = newZoom;
                  });

                  _debounceMarkerCreation();
                }
              }
            },
            onTap: (tapPosition, point) {
              setState(() {
                _selectedEvent = null;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c'],
              tileBuilder: (context, tileWidget, tile) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    themeColors.background.withOpacity(0.1),
                    BlendMode.overlay,
                  ),
                  child: tileWidget,
                );
              },
            ),
            MarkerLayer(
              markers: allMarkers,
            ),
          ],
        ),
        if (_currentZoomLevel >= 16.0)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.small(
              heroTag: "zoom_out",
              onPressed: () {
                _mapController.move(_mapController.center, 12.0);
                setState(() {
                  _currentZoomLevel = 12.0;
                });
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.zoom_out, color: Colors.black),
            ),
          ),
      ],
    );
  }

  Widget _buildEventCards(ThemeData theme, ThemeColors themeColors) {
    if (_selectedEvent == null) {
      return const SizedBox.shrink();
    }

    final eventLocation = _getEventLocation(_selectedEvent!);
    if (eventLocation == null) {
      return const SizedBox.shrink();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final cardTop = (screenHeight * 0.5) + 32;

    return Positioned(
      top: cardTop,
      left: (screenWidth - 300) / 2,
      child: SizedBox(
        height: 200,
        width: 300,
        child: _buildEventCard(_selectedEvent!, theme, themeColors),
      ),
    );
  }

  Widget _buildEventCard(
      EventEntity event, ThemeData theme, ThemeColors themeColors) {
    final imageUrl = event.images?.header ??
        ProjectConfig.defaultEntityImage(EntityType.event);
    final organizerColor = _getOrganizerColor(event);

    return GestureDetector(
      onTap: () => widget.onEventTap(event),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                organizerColor.withOpacity(0.8),
                                organizerColor,
                              ],
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                organizerColor.withOpacity(0.8),
                                organizerColor,
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                right: -20,
                bottom: -10,
                height: 95,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomCenter,
                      radius: 1.8,
                      colors: [
                        Colors.black.withOpacity(0.40),
                        Colors.black.withOpacity(0.30),
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.25, 0.30, 0.40, 0.65, 0.80],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.02),
                        Colors.white.withOpacity(0.05),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.white.withOpacity(0.9), size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location ?? 'Location TBA',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.white.withOpacity(0.9), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _formatEventDateTime(event),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildEventCardPriceWidget(event, theme),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(ThemeData theme, ThemeColors themeColors) {
    return Positioned(
      bottom: 130,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _goToCurrentUserLocation,
                child: Center(
                  child: Transform.rotate(
                    angle: 30 * 3.14159 / 180,
                    child: const Icon(
                      Icons.navigation_outlined,
                      color: Colors.black87,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _launchEvent,
                child: const Center(
                  child: Icon(
                    Icons.groups_3_outlined,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(ThemeData theme, ThemeColors themeColors) {
    return Column(
      children: [
        _buildListTabs(theme, themeColors),
        Expanded(
          child: _buildEventGrid(theme, themeColors),
        ),
      ],
    );
  }

  Widget _buildListTabs(ThemeData theme, ThemeColors themeColors) {
    final tabs = [
      {'tab': ListTab.happeningNow, 'label': 'Happening Now'},
      {'tab': ListTab.topEvents, 'label': 'Top Events'},
      {'tab': ListTab.pickedForYou, 'label': 'Picked for you'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: tabs.map((tabData) {
          final tab = tabData['tab'] as ListTab;
          final isSelected = _selectedListTab == tab;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedListTab = tab);
                if (_currentViewMode == ViewMode.map) {
                  _createEventMarkers();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tabData['label'] as String,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.black87 : Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventGrid(ThemeData theme, ThemeColors themeColors) {
    final events = _getFilteredEvents();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    if (events.isEmpty) {
      return _buildEmptyState(theme, themeColors);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return _buildGridEventCard(event, theme, themeColors);
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ThemeColors themeColors) {
    String message = 'No events found';
    String subtitle = '';

    if (_currentViewMode == ViewMode.list) {
      switch (_selectedListTab) {
        case ListTab.happeningNow:
          message = 'No events happening now';
          subtitle = 'Check back later for live events';
          break;
        case ListTab.topEvents:
          message = 'No top events found';
          subtitle = 'Popular events will appear here';
          break;
        case ListTab.pickedForYou:
          message = 'No events picked for you';
          subtitle = 'Upcoming events in the next 7 days will appear here';
          break;
      }
    } else {
      if (_selectedEventType != null) {
        message = 'No ${_selectedEventType!.toLowerCase()} events found';
        subtitle = 'Try selecting a different event type or location';
      } else if (_selectedLocation != null) {
        message = 'No events found in ${_selectedLocation!.name}';
        subtitle =
            'Try selecting a different location or expanding your search';
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: themeColors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: themeColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: themeColors.onSurfaceVariant.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                widget.onRefreshed(context);
              },
              icon: Icon(Icons.refresh, color: themeColors.primary),
              label: Text(
                'Refresh',
                style: TextStyle(color: themeColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: themeColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridEventCard(
      EventEntity event, ThemeData theme, ThemeColors themeColors) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildEventBackgroundImage(event),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: InkWell(
                onTap: () => widget.onEventTap(event),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  event.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        event.location ?? 'Location TBA',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white70,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        _formatEventDateTime(event),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: _buildGridPriceWidget(event),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridPriceWidget(EventEntity event) {
    final priceValue = event.dynamicFields['price']?.toString();
    final bool isFree = priceValue == null ||
        priceValue.isEmpty ||
        priceValue.toLowerCase() == 'free';

    if (isFree) {
      return const Text(
        'Free',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.end,
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 14,
          ),
          Flexible(
            child: Text(
              priceValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildEventCardPriceWidget(EventEntity event, ThemeData theme) {
    final priceFromGetter = event.price;
    final priceFromDynamicFields = event.dynamicFields['price'];
    
    final priceValue = (priceFromGetter ?? priceFromDynamicFields)?.toString();
    final bool isFree = priceValue == null ||
        priceValue.isEmpty ||
        priceValue.toLowerCase() == 'free' ||
        priceValue == '0' ||
        priceValue == '0.0';

    if (isFree) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.art_track,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'Free',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            priceValue,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    }
  }

  Widget _buildBottomSection(ThemeData theme, ThemeColors themeColors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _currentViewMode == ViewMode.map
              ? [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.9),
                ]
              : [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 0, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBottomActionButtons(theme, themeColors),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(theme, themeColors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons(ThemeData theme, ThemeColors themeColors) {
    final buttons = [
      {'icon': Icons.celebration, 'type': 'Party'},
      {'icon': Icons.group, 'type': 'Group'},
      {'icon': Icons.cake, 'type': 'Birthday'},
      {'icon': Icons.business, 'type': 'Corporate'},
      {'icon': Icons.restaurant, 'type': 'Dinner'},
      {'icon': Icons.store, 'type': 'Shop Opening'},
      {'icon': Icons.favorite, 'type': 'Couplesleeve'},
      {'icon': Icons.music_note, 'type': 'Festival'},
      {'icon': Icons.library_music, 'type': 'Concert'},
      {'icon': Icons.local_bar, 'type': 'Dance Party'},
      {'icon': Icons.waving_hand, 'type': 'Farewell'},
    ];

    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: buttons.asMap().entries.map((entry) {
            final index = entry.key;
            final button = entry.value;
            final buttonType = button['type'] as String;
            final isSelected = _selectedEventType == buttonType;

            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 0,
                right: index < buttons.length - 1 ? 12 : 16,
              ),
              child: GestureDetector(
                onTap: () {
                  if (_showSavedEventView) {
                    setState(() {
                      _selectedEventType = isSelected ? null : buttonType;
                    });
                    if (_currentViewMode == ViewMode.map) {
                      _createEventMarkers();
                    }
                  } else {
                    _searchByCategory(buttonType);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _currentViewMode == ViewMode.map
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _currentViewMode == ViewMode.map
                          ? (isSelected
                              ? Colors.black.withOpacity(0.8)
                              : Colors.grey.withOpacity(0.1))
                          : (isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.white.withOpacity(0.2)),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        button['icon'] as IconData,
                        color: isSelected
                            ? _currentViewMode == ViewMode.map
                                ? Colors.black
                                : Colors.white
                            : _currentViewMode == ViewMode.map
                                ? Colors.grey[600]
                                : Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        buttonType,
                        style: TextStyle(
                          color: isSelected
                              ? _currentViewMode == ViewMode.map
                                  ? Colors.black
                                  : Colors.white
                              : _currentViewMode == ViewMode.map
                                  ? Colors.grey[600]
                                  : Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, ThemeColors themeColors) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _showAddOptionsPopup(context, theme, themeColors);
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white60,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: "What's happening near me?",
              hintStyle: TextStyle(
                color: _currentViewMode == ViewMode.map
                    ? Colors.black54
                    : Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: _currentViewMode == ViewMode.map
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.9),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: _currentViewMode == ViewMode.map
                      ? Colors.grey.withOpacity(0.4)
                      : Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: _currentViewMode == ViewMode.map
                      ? Colors.grey.withOpacity(0.4)
                      : Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: _currentViewMode == ViewMode.map
                      ? Colors.grey.withOpacity(0.6)
                      : Colors.white.withOpacity(0.8),
                  width: 1.5,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: _isAiSearching
                    ? null
                    : () {
                        _performAiSearch();
                      },
                child: _isAiSearching
                    ? Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _currentViewMode == ViewMode.map
                                ? Colors.blue
                                : Colors.blue,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: _currentViewMode == ViewMode.map
                            ? Colors.black87
                            : Colors.black87,
                        size: 20,
                      ),
              ),
            ),
            style: TextStyle(
              color: _currentViewMode == ViewMode.map
                  ? Colors.black
                  : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            onFieldSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                _performAiSearch();
              }
            },
          ),
        ),
      ],
    );
  }

  List<EventEntity> _getFilteredEvents() {
    try {
      List<EventEntity> events = [];

      if (!_showSavedEventView) {
        for (final message in _chatMessages) {
          if (message.type == ChatMessageType.ai &&
              message.events != null &&
              message.events!.isNotEmpty) {
            events.addAll(message.events!);
          }
        }

        if (events.isNotEmpty) {
          return _applyFiltersToEventList(events);
        }
      }

      final eventMap = widget.state.getEntityMap(EntityType.event);

      if (eventMap == null || eventMap.isEmpty) {
        return [];
      }

      events = widget.entityList
          .where((id) => id != null && eventMap.containsKey(id))
          .map((id) {
            try {
              final event = eventMap[id] as EventEntity?;
              if (event == null) {
                return null;
              }
              return event;
            } catch (e) {
              logError('Error getting event $id: $e');
              return null;
            }
          })
          .where((event) => event != null)
          .cast<EventEntity>()
          .toList();

      return _applyFiltersToEventList(events);
    } catch (e) {
      logError('Error in _getFilteredEvents: $e');
      return [];
    }
  }

  List<EventEntity> _applyFiltersToEventList(List<EventEntity> events) {
    try {
      List<EventEntity> locationFilteredEvents = events;

      if (_selectedLocation != null &&
          _selectedLocation!.latitude != null &&
          _selectedLocation!.longitude != null) {
        locationFilteredEvents = events.where((event) {
          try {
            final eventLocation = _getEventLocation(event);

            if (eventLocation != null) {
              final distance = _calculateDistance(
                _selectedLocation!.latitude!,
                _selectedLocation!.longitude!,
                eventLocation.latitude,
                eventLocation.longitude,
              );
              final isWithinRange = distance <= 50.0;
              return isWithinRange;
            }
            return true;
          } catch (e) {
            logError('Error filtering event by location ${event.id}: $e');
            return true;
          }
        }).toList();
      }

      final typeFilteredEvents = _selectedEventType != null
          ? locationFilteredEvents.where((event) {
              try {
                final mainEventType = event.eventType?.trim() ?? '';

                String dynamicEventType = '';
                final dynamicFieldEventType = event.dynamicFields['eventType'];
                if (dynamicFieldEventType != null) {
                  dynamicEventType = dynamicFieldEventType.toString().trim();
                }

                final selectedType = _selectedEventType!.trim();

                bool matches =
                    mainEventType.toLowerCase() == selectedType.toLowerCase() ||
                        dynamicEventType.toLowerCase() ==
                            selectedType.toLowerCase();

                return matches;
              } catch (e) {
                logError('Error filtering event by type ${event.id}: $e');
                return false;
              }
            }).toList()
          : locationFilteredEvents;

      final filteredEvents = _currentViewMode == ViewMode.list
          ? _applyTabFiltering(typeFilteredEvents)
          : typeFilteredEvents;

      return filteredEvents;
    } catch (e) {
      logError('Error in _applyFiltersToEventList: $e');
      return events;
    }
  }

  List<EventEntity> _applyTabFiltering(List<EventEntity> events) {
    final now = DateTime.now();

    switch (_selectedListTab) {
      case ListTab.happeningNow:
        final filtered = events.where((event) {
          try {
            final start = event.start;
            final end = event.end;

            if (start > 0 && end > 0) {
              final startDate =
                  DateTime.fromMillisecondsSinceEpoch(start * 1000);
              final endDate = DateTime.fromMillisecondsSinceEpoch(end * 1000);

              final isHappening =
                  now.isAfter(startDate) && now.isBefore(endDate);

              return isHappening;
            } else if (start > 0) {
              final startDate =
                  DateTime.fromMillisecondsSinceEpoch(start * 1000);
              final hoursSinceStart = now.difference(startDate).inHours;

              return hoursSinceStart >= 0 && hoursSinceStart <= 24;
            }

            return false;
          } catch (e) {
            logError('Error filtering happening now events: $e');
            return false;
          }
        }).toList();

        return filtered;

      case ListTab.topEvents:
        final sortedEvents = List<EventEntity>.from(events);
        sortedEvents.sort((a, b) {
          int scoreA = (a.views?.length ?? 0) +
              (a.favourites?.length ?? 0) * 2 +
              (a.joinRequests?.length ?? 0);
          int scoreB = (b.views?.length ?? 0) +
              (b.favourites?.length ?? 0) * 2 +
              (b.joinRequests?.length ?? 0);
          return scoreB.compareTo(scoreA);
        });
        return sortedEvents.take(20).toList();

      case ListTab.pickedForYou:
        return events.where((event) {
          try {
            final start = event.start;
            if (start > 0) {
              final startDate =
                  DateTime.fromMillisecondsSinceEpoch(start * 1000);
              final daysDifference = startDate.difference(now).inDays;
              return daysDifference >= 0 && daysDifference <= 7;
            }
            return false;
          } catch (e) {
            logError('Error filtering picked for you events: $e');
            return false;
          }
        }).toList();
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  void _centerMapOnUserLocation() {
    LatLng? targetLocation;

    if (_selectedLocation != null &&
        _selectedLocation!.latitude != null &&
        _selectedLocation!.longitude != null) {
      targetLocation =
          LatLng(_selectedLocation!.latitude!, _selectedLocation!.longitude!);
    } else if (_currentUserLocation != null) {
      targetLocation = _currentUserLocation;
    } else {
      targetLocation = _defaultLocation;
    }

    _locationTimer?.cancel();
    _locationTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted && _currentViewMode == ViewMode.map) {
        _mapController.move(targetLocation!, _defaultZoom);
        setState(() {
          _currentZoomLevel = _defaultZoom;
        });
        _createEventMarkers();
      }
    });
  }

  void _goToCurrentUserLocation() async {
    if (_currentUserLocation != null) {
      _mapController.move(_currentUserLocation!, _defaultZoom);
      setState(() {
        _currentZoomLevel = _defaultZoom;
      });
      _createEventMarkers();
    } else {
      try {
        final location = await LocationService.getCurrentLocation();
        if (location != null && mounted) {
          final currentLocation = LatLng(
            location['latitude']!,
            location['longitude']!,
          );

          final locationName =
              await LocationService.getCurrentLocationAndAddress();

          setState(() {
            _currentUserLocation = currentLocation;
            _userLocation = locationName ?? 'Current Location';
            _selectedLocation = LocationSuggestion(
              name: 'Current Location',
              fullAddress: locationName ?? 'Current Location',
              city: locationName ?? 'Current Location',
              state: '',
              country: '',
              postalCode: '',
              latitude: location['latitude']!,
              longitude: location['longitude']!,
            );
          });

          _mapController.move(currentLocation, _defaultZoom);
          setState(() {
            _currentZoomLevel = _defaultZoom;
          });
          _createEventMarkers();
        } else {
          _setDefaultLocationAsCurrentLocation();
          _mapController.move(_defaultLocation, _defaultZoom);
          setState(() {
            _currentZoomLevel = _defaultZoom;
          });
          _createEventMarkers();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Location not available, showing default location'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        logError('Error getting current location: $e');
        _setDefaultLocationAsCurrentLocation();
        _mapController.move(_defaultLocation, _defaultZoom);
        setState(() {
          _currentZoomLevel = _defaultZoom;
        });
        _createEventMarkers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Location service not available, showing default location'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _launchEvent() {
    if (mounted) {
      createEntityByType(
        context: context,
        entityType: EntityType.event,
      );
    }
  }

  String _formatEventDateTime(EventEntity event) {
    if (event.start > 0) {
      final startDate = DateTime.fromMillisecondsSinceEpoch(event.start * 1000);
      final now = DateTime.now();

      if (startDate.day == now.day &&
          startDate.month == now.month &&
          startDate.year == now.year) {
        return 'Today, ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
      } else {
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return '${months[startDate.month - 1]} ${startDate.day}, ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
      }
    }
    return 'Date TBA';
  }

  Color _getOrganizerColor(EventEntity event) {
    final colors = [
      const Color(0xFFE53E3E),
      const Color(0xFF38A169),
      const Color(0xFF3182CE),
      const Color(0xFFE91E63),
      const Color(0xFFD69E2E),
      const Color(0xFF9F7AEA),
      const Color(0xFF00B5D8),
      const Color(0xFFFF8A80),
      const Color(0xFF81C784),
      const Color(0xFF64B5F6),
    ];

    final index = event.id.hashCode % colors.length;
    return colors[index.abs()];
  }

  Future<void> _createEventMarkers() async {
    try {
      final events = _getFilteredEvents();
      final List<Marker> markers = [];

      final Map<String, List<EventEntity>> eventsByLocation = {};

      for (final event in events) {
        final eventLocation = _getEventLocation(event);
        if (eventLocation != null) {
          final precision = _getLocationPrecision(_currentZoomLevel);
          final locationKey =
              '${eventLocation.latitude.toStringAsFixed(precision)},${eventLocation.longitude.toStringAsFixed(precision)}';
          if (!eventsByLocation.containsKey(locationKey)) {
            eventsByLocation[locationKey] = [];
          }
          eventsByLocation[locationKey]!.add(event);
        }
      }

      for (final entry in eventsByLocation.entries) {
        try {
          final eventsAtLocation = entry.value;

          if (eventsAtLocation.length == 1) {
            final event = eventsAtLocation.first;
            final eventLocation = _getEventLocation(event);
            if (eventLocation != null) {
              final marker = Marker(
                point: eventLocation,
                width: 130,
                height: 30,
                builder: (context) => _buildSingleMarkerWidget(event),
              );
              markers.add(marker);
            }
          } else {
            _createClusteredMarkers(eventsAtLocation, markers);
          }
        } catch (e) {
          logError('Error creating marker for location: $e');
        }
      }

      if (mounted) {
        setState(() {
          _markers = markers;
        });
      }
    } catch (e) {
      logError('Error in _createEventMarkers: $e');
    }
  }

  void _fetchEventsForNewLocation() {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadEvents(isRefresh: true));

      if (!_showSavedEventView) {
        _performInitialAiSearch();
      }

      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _createEventMarkers();
        }
      });
  }

  void _debounceMarkerCreation() {
    _markerCreationTimer?.cancel();
    _markerCreationTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _createEventMarkers();
      }
    });
  }

  int _getLocationPrecision(double zoomLevel) {
    if (zoomLevel >= 15.0) return 6;
    if (zoomLevel >= 12.0) return 5;
    if (zoomLevel >= 8.0) return 4;
    return 3;
  }

  void _createClusteredMarkers(
      List<EventEntity> eventsAtLocation, List<Marker> markers) {
    if (eventsAtLocation.isEmpty) return;

    eventsAtLocation.sort((a, b) {
      if (a.start > 0 && b.start > 0) {
        return b.start.compareTo(a.start);
      }
      return b.id.compareTo(a.id);
    });

    if (_currentZoomLevel >= 17.0) {
      _createAllIndividualMarkers(eventsAtLocation, markers);
    } else if (_currentZoomLevel >= 15.0) {
      _createOffsetMarkers(eventsAtLocation, markers);
    } else if (_currentZoomLevel >= 12.0) {
      _createMediumZoomMarkers(eventsAtLocation, markers);
    } else {
      final latestEvent = eventsAtLocation.first;
      final eventLocation = _getEventLocation(latestEvent);
      if (eventLocation != null) {
        final marker = Marker(
          point: eventLocation,
          width: 130,
          height: 30,
          builder: (context) => _buildClusterMarkerWidget(
              latestEvent, eventsAtLocation.length, eventsAtLocation),
        );
        markers.add(marker);
      }
    }
  }

  void _createAllIndividualMarkers(
      List<EventEntity> events, List<Marker> markers) {
    const double offsetDistance = 0.0003;

    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final baseLocation = _getEventLocation(event);
      if (baseLocation == null) continue;

      final angle = (i * 2 * 3.14159) / math.max(6, events.length);
      final radius = offsetDistance * (i / 6).ceil();
      final offsetLat = baseLocation.latitude + (radius * math.cos(angle));
      final offsetLng = baseLocation.longitude + (radius * math.sin(angle));

      final marker = Marker(
        point: LatLng(offsetLat, offsetLng),
        width: 130,
        height: 30,
        builder: (context) => _buildSingleMarkerWidget(event),
      );
      markers.add(marker);
    }
  }

  void _createOffsetMarkers(List<EventEntity> events, List<Marker> markers) {
    const double offsetDistance = 0.0003;
    final int maxMarkers = events.length > 8 ? 8 : events.length;

    for (int i = 0; i < maxMarkers; i++) {
      final event = events[i];
      final baseLocation = _getEventLocation(event);
      if (baseLocation == null) continue;

      final angle = (i * 2 * 3.14159) / 6;
      final radius = (i > 0) ? offsetDistance * ((i / 6).ceil()) : 0;
      final offsetLat = baseLocation.latitude + (radius * math.cos(angle));
      final offsetLng = baseLocation.longitude + (radius * math.sin(angle));

      final marker = Marker(
        point: LatLng(offsetLat, offsetLng),
        width: 130,
        height: 30,
        builder: (context) => _buildSingleMarkerWidget(event),
      );
      markers.add(marker);
    }

    if (events.length > maxMarkers) {
      final baseLocation = _getEventLocation(events.first);
      if (baseLocation != null) {
        final remainingEvents = events.sublist(maxMarkers);
        final marker = Marker(
          point: LatLng(
            baseLocation.latitude + offsetDistance * 1.5,
            baseLocation.longitude + offsetDistance * 1.5,
          ),
          width: 40,
          height: 40,
          builder: (context) => _buildMoreEventsIndicator(
              events.length - maxMarkers, remainingEvents),
        );
        markers.add(marker);
      }
    }
  }

  void _createMediumZoomMarkers(
      List<EventEntity> events, List<Marker> markers) {
    final latestEvent = events.first;
    final eventLocation = _getEventLocation(latestEvent);
    if (eventLocation != null) {
      if (events.length > 1) {
        final marker = Marker(
          point: eventLocation,
          width: 130,
          height: 30,
          builder: (context) =>
              _buildClusterMarkerWidget(latestEvent, events.length, events),
        );
        markers.add(marker);
      } else {
        final marker = Marker(
          point: eventLocation,
          width: 130,
          height: 30,
          builder: (context) => _buildSingleMarkerWidget(latestEvent),
        );
        markers.add(marker);
      }
    }
  }

  Widget _buildSingleMarkerWidget(EventEntity event) {
    final markerIcon = _createEventMarkerIcon(event);
    final isSelected = _selectedEvent?.id == event.id;

    return GestureDetector(
      onTap: () => _onMarkerTapped(event),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 130,
          minWidth: 60,
        ),
        child: IntrinsicWidth(
          child: SizedBox(
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 32,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black
                          : Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isSelected
                              ? Colors.black
                              : Colors.white.withOpacity(0.3),
                          width: 1),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isSelected ? 0.3 : 0.1),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          markerIcon['icon'],
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            event.eventType ?? event.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClusterMarkerWidget(EventEntity mainEvent, int eventCount,
      [List<EventEntity>? eventsAtLocation]) {
    final markerIcon = _createEventMarkerIcon(mainEvent);
    final isSelected = _selectedEvent?.id == mainEvent.id;

    return GestureDetector(
      onTap: () =>
          _onClusterMarkerTapped(mainEvent, eventsAtLocation ?? [mainEvent]),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 150,
          minWidth: 80,
        ),
        child: IntrinsicWidth(
          child: SizedBox(
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 32,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black
                          : Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isSelected
                              ? Colors.black
                              : Colors.white.withOpacity(0.3),
                          width: 1),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isSelected ? 0.3 : 0.1),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          markerIcon['icon'],
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${mainEvent.eventType ?? mainEvent.name} +${eventCount - 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreEventsIndicator(int additionalCount,
      [List<EventEntity>? remainingEvents]) {
    return GestureDetector(
      onTap: () {
        _mapController.move(_mapController.center, 18.0);
        setState(() {
          _currentZoomLevel = 18.0;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          _createEventMarkers();
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '+$additionalCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _fitMapToBounds() {
    if (_mapBounds != null && _mapBounds!.isNotEmpty) {
      try {
        final bounds = LatLngBounds(
          LatLng(_mapBounds!['min_lat']!, _mapBounds!['min_lng']!),
          LatLng(_mapBounds!['max_lat']!, _mapBounds!['max_lng']!),
        );

        _mapController.fitBounds(
          bounds,
          options: const FitBoundsOptions(
            padding: EdgeInsets.all(50),
            maxZoom: 15.0,
          ),
        );
      } catch (e) {
        logError('Error fitting map to bounds: $e');
      }
    }
  }

  LatLng? _getEventLocation(EventEntity event) {
    try {
      if (event.locationData != null) {
        final lat = event.locationData!.lat;
        final lng = event.locationData!.lng;
        if (lat != 0.0 || lng != 0.0) {
          return LatLng(lat, lng);
        }
      }
    } catch (e) {
      logError('Error parsing locationData from event.locationData: $e');
    }

    try {
      final locationDataField = event.dynamicFields['locationData'];
      if (locationDataField is Map<String, dynamic>) {
        final lat = locationDataField['lat'];
        final lng = locationDataField['lng'] ?? locationDataField['long'];
        if (lat is num && lng is num) {
          return LatLng(lat.toDouble(), lng.toDouble());
        }
      }
    } catch (e) {
      logError('Error parsing locationData from dynamicFields: $e');
    }

    final eventLocations = [
      const LatLng(-37.828253, 144.652391),
      const LatLng(-37.8136, 144.9631),
      const LatLng(-37.8182, 144.9647),
      const LatLng(-37.8036, 144.9631),
      const LatLng(-37.8136, 144.9831),
      const LatLng(-37.8336, 144.9631),
      const LatLng(-37.7936, 144.9431),
      const LatLng(-37.8236, 144.9831),
      const LatLng(-37.8036, 144.9831),
      const LatLng(-37.8436, 144.9631),
    ];

    final index = event.id.hashCode % eventLocations.length;
    return eventLocations[index.abs()];
  }

  void _onMarkerTapped(EventEntity event) {
    setState(() {
      _selectedEvent = event;
    });

    _createEventMarkers();

    final eventLocation = _getEventLocation(event);
    if (eventLocation != null) {
      const padding = 0.005;
      final bounds = LatLngBounds(
        LatLng(
          eventLocation.latitude - padding,
          eventLocation.longitude - padding,
        ),
        LatLng(
          eventLocation.latitude + padding,
          eventLocation.longitude + padding,
        ),
      );

      _mapController.fitBounds(
        bounds,
        options: const FitBoundsOptions(
          padding: EdgeInsets.all(50),
          maxZoom: 16.0,
        ),
      );
    }

    if (!_showSavedEventView) {
      _openEventDetails(event);
    }
  }

  void _onClusterMarkerTapped(
      EventEntity mainEvent, List<EventEntity> eventsAtLocation) {
    final eventLocation = _getEventLocation(mainEvent);
    if (eventLocation != null) {
      _mapController.move(eventLocation, 18.0);
      setState(() {
        _currentZoomLevel = 18.0;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _createEventMarkers();
      });
    }
  }

  Map<String, dynamic> _createEventMarkerIcon(EventEntity event) {
    final mainEventType = event.eventType?.trim() ?? '';
    String dynamicEventType = '';
    final dynamicFieldEventType = event.dynamicFields['eventType'];
    if (dynamicFieldEventType != null) {
      dynamicEventType = dynamicFieldEventType.toString().trim();
    }

    String eventTypeToMatch =
        mainEventType.isNotEmpty ? mainEventType : dynamicEventType;

    final eventTypeIcons = <String, Map<String, dynamic>>{
      'Party': {'icon': Icons.celebration, 'color': const Color(0xFFE53E3E)},
      'Group': {'icon': Icons.group, 'color': const Color(0xFF38A169)},
      'Birthday': {'icon': Icons.cake, 'color': const Color(0xFFE91E63)},
      'Corporate': {'icon': Icons.business, 'color': const Color(0xFF3182CE)},
      'Dinner': {'icon': Icons.restaurant, 'color': const Color(0xFFFF8A80)},
      'Shop Opening': {'icon': Icons.store, 'color': const Color(0xFF81C784)},
      'Couplesleeve': {
        'icon': Icons.favorite,
        'color': const Color(0xFFEC407A)
      },
      'Festival': {'icon': Icons.music_note, 'color': const Color(0xFFD69E2E)},
      'Concert': {
        'icon': Icons.library_music,
        'color': const Color(0xFFFFB74D)
      },
      'Dance Party': {
        'icon': Icons.local_bar,
        'color': const Color(0xFFBA68C8)
      },
      'Farewell': {'icon': Icons.waving_hand, 'color': const Color(0xFF64B5F6)},
    };

    if (eventTypeIcons.containsKey(eventTypeToMatch)) {
      return eventTypeIcons[eventTypeToMatch]!;
    }

    return {'icon': Icons.event, 'color': const Color(0xFF9E9E9E)};
  }

  Widget _buildLocationDropdown(ThemeData theme, ThemeColors themeColors) {
    return Positioned(
      top: _currentViewMode == ViewMode.map ? 90 : 90,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {},
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: themeColors.background,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedLocation != null) ...[
                  _buildLocationDropdownItem(
                    _selectedLocation!,
                    theme,
                    themeColors,
                    isCurrentLocation: true,
                    isSelected: true,
                  ),
                  if (_nearbyLocations.isNotEmpty)
                    Divider(
                        height: 1,
                        color: themeColors.onSurfaceVariant.withOpacity(0.2)),
                ],
                if (_nearbyLocations.isNotEmpty) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.near_me,
                          color: themeColors.onSurfaceVariant,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nearby Locations',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: themeColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...(_nearbyLocations
                      .take(8)
                      .map((location) => _buildLocationDropdownItem(
                            location,
                            theme,
                            themeColors,
                            isCurrentLocation: false,
                            isSelected: () {
                              if (_selectedLocation == null) return false;

                              final coordinatesMatch =
                                  _selectedLocation!.latitude != null &&
                                      _selectedLocation!.longitude != null &&
                                      location.latitude != null &&
                                      location.longitude != null &&
                                      (_selectedLocation!.latitude! -
                                                  location.latitude!)
                                              .abs() <
                                          0.0001 &&
                                      (_selectedLocation!.longitude! -
                                                  location.longitude!)
                                              .abs() <
                                          0.0001;

                              final nameMatch = _selectedLocation!.name
                                      .toLowerCase()
                                      .trim() ==
                                  location.name.toLowerCase().trim();

                              final isSelected = coordinatesMatch || nameMatch;

                              return isSelected;
                            }(),
                          ))),
                  Divider(
                      height: 1,
                      color: themeColors.onSurfaceVariant.withOpacity(0.2)),
                  _buildRefreshLocationItem(theme, themeColors),
                ],
                if (_isLoadingLocation)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Getting your location...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: themeColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_isLoadingNearbyLocations)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading nearby locations...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: themeColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_nearbyLocations.isEmpty && _selectedLocation != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: themeColors.onSurfaceVariant,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'No nearby locations found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: themeColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_nearbyLocations.isEmpty && _selectedLocation == null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_off,
                          color: themeColors.onSurfaceVariant,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'No locations available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: themeColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDropdownItem(
    LocationSuggestion location,
    ThemeData theme,
    ThemeColors themeColors, {
    required bool isCurrentLocation,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        if (location.latitude == null || location.longitude == null) return;

        final selectedLatLng = LatLng(location.latitude!, location.longitude!);

        setState(() {
          _selectedLocation = location;
          _userLocation =
              location.city.isNotEmpty ? location.city : location.name;
          _showLocationDropdown = false;
          _currentUserLocation = selectedLatLng;
        });

        if (_currentViewMode == ViewMode.map) {
          _locationTimer?.cancel();
          _locationTimer = Timer(const Duration(milliseconds: 100), () {
            if (mounted) {
              _mapController.move(selectedLatLng, _defaultZoom);
              _fetchEventsForNewLocation();
            }
          });
        }

        await _loadNearbyLocations(location.name);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isCurrentLocation ? Icons.my_location : Icons.location_on,
              color: isCurrentLocation
                  ? themeColors.primary
                  : (isSelected
                      ? themeColors.primary
                      : themeColors.onSurfaceVariant),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCurrentLocation ? 'Current Location' : location.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isSelected ? themeColors.primary : themeColors.text,
                      fontWeight: isCurrentLocation || isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location.city.isNotEmpty && !isCurrentLocation)
                    Text(
                      location.city,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: themeColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: themeColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefreshLocationItem(ThemeData theme, ThemeColors themeColors) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _showLocationDropdown = false;
          _locationInitialized = false;
        });

        await _getCurrentUserLocation();

        if (mounted) {
          _fetchEventsForNewLocation();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location updated'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.refresh,
              color: themeColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Refresh Current Location',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: themeColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performAiSearch() {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty && !_isAiSearching) {
      _clearPreviousEventResponses();

      _addUserMessage(searchText);

      _addLoadingMessage();

      setState(() {
        _isAiSearching = true;
      });

      final store = StoreProvider.of<AppState>(context);

      double? userLat;
      double? userLng;
      String? locationName;

      if (_currentUserLocation != null) {
        userLat = _currentUserLocation!.latitude;
        userLng = _currentUserLocation!.longitude;
      }

      if (_selectedLocation != null) {
        userLat = _selectedLocation!.latitude;
        userLng = _selectedLocation!.longitude;
        locationName = _selectedLocation!.name;
      } else {
        locationName = _userLocation;
      }

      final completer = Completer<List<EventEntity>>();

      completer.future.then((events) {
        if (mounted) {
          _removeLoadingMessage();

          final responseText = events.isNotEmpty
              ? "I found ${events.length} events matching your search!"
              : "I couldn't find any events matching your search criteria.";

          _addAIResponse(responseText, events: events);

          setState(() {
            _isAiSearching = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          _removeLoadingMessage();

          _addAIResponse(
              "Sorry, I encountered an error while searching for events. Please try again.");

          setState(() {
            _isAiSearching = false;
          });
        }
      });

      store.dispatch(ChatWithAi(
        message: searchText,
        completer: completer,
        userLatitude: userLat,
        userLongitude: userLng,
        userLocationName: locationName,
      ));

      _searchController.clear();
    }
  }

  void _searchByCategory(String categoryName) {
    if (!_isAiSearching) {
      final prompt = _generateCategoryPrompt(categoryName);

      _searchController.text = prompt;

      if (!_isChatOpen) {
        setState(() {
          _isChatOpen = true;
        });
      }

      _clearPreviousEventResponses();

      _addUserMessage(prompt);

      _addLoadingMessage();

      setState(() {
        _isAiSearching = true;
      });

      final store = StoreProvider.of<AppState>(context);

      double? userLat;
      double? userLng;
      String? locationName;

      if (_currentUserLocation != null) {
        userLat = _currentUserLocation!.latitude;
        userLng = _currentUserLocation!.longitude;
      }

      if (_selectedLocation != null) {
        userLat = _selectedLocation!.latitude;
        userLng = _selectedLocation!.longitude;
        locationName = _selectedLocation!.name;
      } else {
        locationName = _userLocation;
      }

      final completer = Completer<List<EventEntity>>();

      completer.future.then((events) {
        if (mounted) {
          _removeLoadingMessage();

          final responseText = events.isNotEmpty
              ? "I found ${events.length} ${categoryName.toLowerCase()} events near you!"
              : "I couldn't find any ${categoryName.toLowerCase()} events in your area right now.";

          _addAIResponse(responseText, events: events);

          setState(() {
            _isAiSearching = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          _removeLoadingMessage();

          _addAIResponse(
              "Sorry, I encountered an error while searching for ${categoryName.toLowerCase()} events. Please try again.");

          setState(() {
            _isAiSearching = false;
          });
        }
      });

      store.dispatch(ChatWithAi(
        message: prompt,
        completer: completer,
        userLatitude: userLat,
        userLongitude: userLng,
        userLocationName: locationName,
      ));

      _searchController.clear();
    }
  }

  String _generateCategoryPrompt(String categoryName) {
    final locationText = _selectedLocation?.name ?? _userLocation;

    switch (categoryName.toLowerCase()) {
      case 'party':
        return 'Find fun party and celebration events happening near $locationText';
      case 'group':
        return 'Show me group events and social gatherings in $locationText';
      case 'birthday':
        return 'Find birthday parties and celebration venues available in $locationText';
      case 'corporate':
        return 'Show me business networking events, conferences, and professional meetups in $locationText';
      case 'dinner':
        return 'Show me dining events, food festivals, and restaurant experiences in $locationText';
      case 'shop opening':
        return 'Find shop openings, grand openings, and retail events in $locationText';
      case 'couplesleeve':
        return 'Show me romantic events, date nights, and couples activities in $locationText';
      case 'festival':
        return 'Find music festivals, arts festivals, and cultural events near $locationText';
      case 'concert':
        return 'Show me concerts, live music, and musical performances in $locationText';
      case 'dance party':
        return 'Find dance parties, club events, and nightlife in $locationText';
      case 'farewell':
        return 'Show me farewell parties, going away events, and goodbye celebrations in $locationText';
      default:
        return 'Find ${categoryName.toLowerCase()} events happening near $locationText';
    }
  }

  void _performInitialAiSearch() {
    if (_isAiSearching) return;

    final locationText = _selectedLocation?.name ?? _userLocation;
    final defaultPrompt =
        'Show me interesting events and activities happening near $locationText today and this week';

    _searchController.text = defaultPrompt;

    _clearPreviousEventResponses();

    _addUserMessage(defaultPrompt);

    _addLoadingMessage();

    setState(() {
      _isAiSearching = true;
    });

    final store = StoreProvider.of<AppState>(context);

    double? userLat;
    double? userLng;
    String? locationName;

    if (_currentUserLocation != null) {
      userLat = _currentUserLocation!.latitude;
      userLng = _currentUserLocation!.longitude;
    }

    if (_selectedLocation != null) {
      userLat = _selectedLocation!.latitude;
      userLng = _selectedLocation!.longitude;
      locationName = _selectedLocation!.name;
    } else {
      locationName = _userLocation;
    }

    final completer = Completer<List<EventEntity>>();

    completer.future.then((events) {
      if (mounted) {
        _removeLoadingMessage();

        final responseText = events.isNotEmpty
            ? "Welcome! I found ${events.length} exciting events happening near you!"
            : "Welcome! I couldn't find any events in your area right now, but keep checking back for new events.";

        _addAIResponse(responseText, events: events);

        setState(() {
          _isAiSearching = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        _removeLoadingMessage();

        _addAIResponse(
            "Welcome! I'm having trouble finding events right now, but you can try searching for specific types of events.");

        setState(() {
          _isAiSearching = false;
        });
      }
    });

    store.dispatch(ChatWithAi(
      message: defaultPrompt,
      completer: completer,
      userLatitude: userLat,
      userLongitude: userLng,
      userLocationName: locationName,
    ));

    _searchController.clear();
  }

  Widget _buildChatBottomSheet(ThemeData theme, ThemeColors themeColors) {
    final bottomSectionHeight = (_showSavedEventView ? 60 + 12 : 0) + 40 + 32;

    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight -
        bottomSectionHeight -
        MediaQuery.of(context).padding.top -
        20;

    return Positioned(
      bottom: bottomSectionHeight.toDouble(),
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              minHeight: _chatMessages.isEmpty ? 300 : 200,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isChatOpen = false;
                          });
                          _searchFocusNode.unfocus();
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black54,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: _buildChatMessages(theme, themeColors),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessages(ThemeData theme, ThemeColors themeColors) {
    if (_chatMessages.isEmpty) {
      return SizedBox(
        height: 250,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.waving_hand,
                color: Colors.black54,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Hello! Ask me about events near you',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try: "Find restaurants near me" or "Show parties tonight"',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black38,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final maxMessagesHeight = screenHeight * 0.6;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxMessagesHeight,
        minHeight: 200,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: _chatMessages.length,
        itemBuilder: (context, index) {
          final message = _chatMessages[index];
          return _buildChatMessageBubble(message, theme, themeColors);
        },
      ),
    );
  }

  Widget _buildChatMessageBubble(
      ChatMessage message, ThemeData theme, ThemeColors themeColors) {
    final isUser = message.type == ChatMessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: message.isLoading
                      ? _buildTypingIndicator()
                      : Text(
                          message.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (message.events != null && message.events!.isNotEmpty)
            _buildEventsSection(message.events!, theme, themeColors),
        ],
      ),
    );
  }

  Widget _buildEventsSection(
      List<EventEntity> events, ThemeData theme, ThemeColors themeColors) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...events
              .map((event) => _buildModernEventCard(event, theme, themeColors))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildModernEventCard(
      EventEntity event, ThemeData theme, ThemeColors themeColors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildEventBackgroundImage(event),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: InkWell(
                onTap: () => _openEventDetails(event),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  event.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        event.location ?? 'Location TBA',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatEventDateTime(event),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.dynamicFields['price']?.toString() ??
                                  'Free',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventBackgroundImage(EventEntity event) {
    String? imageUrl;

    if (event.images?.header != null && event.images!.header.isNotEmpty) {
      imageUrl = event.images!.header;
    } else if (event.images?.thumbnail != null &&
        event.images!.thumbnail.isNotEmpty) {
      imageUrl = event.images!.thumbnail;
    } else {
      final dynamicFields = event.dynamicFields;
      if (dynamicFields.containsKey('images')) {
        final images = dynamicFields['images'];
        if (images is List && images.isNotEmpty) {
          final firstImage = images.first;
          if (firstImage is String) {
            imageUrl = firstImage;
          } else if (firstImage is Map<String, dynamic> &&
              firstImage.containsKey('url')) {
            imageUrl = firstImage['url'].toString();
          }
        }
      }
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultEventBackground(event);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildDefaultEventBackground(event);
        },
      );
    }

    return _buildDefaultEventBackground(event);
  }

  Widget _buildDefaultEventBackground(EventEntity event) {
    Color backgroundColor = Colors.blue;
    IconData icon = Icons.event;

    final title = event.name.toLowerCase();
    if (title.contains('restaurant') ||
        title.contains('food') ||
        title.contains('dinner')) {
      backgroundColor = Colors.orange;
      icon = Icons.restaurant;
    } else if (title.contains('party') || title.contains('celebration')) {
      backgroundColor = Colors.purple;
      icon = Icons.celebration;
    } else if (title.contains('music') || title.contains('concert')) {
      backgroundColor = Colors.red;
      icon = Icons.music_note;
    } else if (title.contains('business') || title.contains('corporate')) {
      backgroundColor = Colors.blue;
      icon = Icons.business;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor.withOpacity(0.8),
            backgroundColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }

  String _getEventLocationString(EventEntity event) {
    try {
      final dynamicFields = event.dynamicFields;
      if (dynamicFields.containsKey('location')) {
        final location = dynamicFields['location'];
        if (location is Map<String, dynamic>) {
          final address = location['address'] as String?;
          if (address != null && address.isNotEmpty) {
            return address;
          }
        }
      }
      return 'Location not specified';
    } catch (e) {
      return 'Location not specified';
    }
  }

  void _openEventDetails(EventEntity event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildEventDetailSheet(event),
    );
  }

  Widget _buildEventDetailSheet(EventEntity event) {
    final imageUrl = event.images?.header ??
        ProjectConfig.defaultEntityImage(EntityType.event);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const SizedBox.shrink(),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.event,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.event,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.15),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (event.eventType?.isNotEmpty == true)
                            Text(
                              event.eventType!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (event.description.isNotEmpty) ...[
                            Text(
                              event.description,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          _buildEventDetailRowForSheet(
                            Icons.schedule,
                            'When',
                            _formatEventDateTime(event),
                          ),
                          const SizedBox(height: 12),
                          _buildEventDetailRowForSheet(
                            Icons.location_on,
                            'Where',
                            _getEventLocationString(event),
                            showMapButton: true,
                            onMapTap: () => _openInMaps(event),
                          ),
                          const SizedBox(height: 12),
                          if (event.joinRequests?.isNotEmpty == true)
                            _buildEventDetailRowForSheet(
                              Icons.people_outline,
                              'Attendees',
                              '${event.joinRequests!.length} going',
                            ),
                          const SizedBox(height: 24),
                          if (event.url.isNotEmpty)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  appView.openUrl(
                                      context, event.url, "Let's go!");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.launch,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Let's go!",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailRowForSheet(
    IconData icon,
    String title,
    String value, {
    bool showMapButton = false,
    VoidCallback? onMapTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (showMapButton) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onMapTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Searching...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            _buildAnimatedDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _radarAnimationController,
          builder: (context, child) {
            final animationValue = _radarAnimationController.value;
            final delay = index * 0.3;
            double scale = 1.0;

            // Create a more typical typing indicator animation
            final adjustedValue = (animationValue + delay) % 1.0;
            if (adjustedValue < 0.5) {
              scale = 0.5 + (adjustedValue * 2) * 0.5;
            } else {
              scale = 1.0 - ((adjustedValue - 0.5) * 2) * 0.5;
            }

            return Container(
              margin: EdgeInsets.only(right: index < 2 ? 3 : 0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> _openInMaps(EventEntity event) async {
    final location = _getEventLocation(event);
    if (location != null) {
      final lat = location.latitude;
      final lng = location.longitude;

      try {
        String url;

        if (kIsWeb) {
          url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        } else {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            url = 'https://maps.apple.com/?q=$lat,$lng';
          } else {
            url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
          }
        }

        appView.openUrl(context, url, 'Open in Maps');
      } catch (e) {
        logError('Error opening maps: $e');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open maps application'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _showAddOptionsPopup(
      BuildContext context, ThemeData theme, ThemeColors themeColors) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: 25,
              bottom: 60,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPopupMenuItem(
                        iconAsset: 'assets/opw/logo.png',
                        title: 'Marketplace',
                        isLocked: true,
                        onTap: null,
                      ),
                      _buildPopupMenuItem(
                        icon: Icons.chat_outlined,
                        title: 'OpenChat',
                        subtitle: '(coming soon)',
                        onTap: null,
                      ),
                      _buildPopupMenuItem(
                        icon: Icons.groups_outlined,
                        title: 'Launch an event',
                        onTap: () {
                          Navigator.of(context).pop();
                          createEntityByType(
                            context: context,
                            entityType: EntityType.event,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopupMenuItem({
    IconData? icon,
    String? iconAsset,
    required String title,
    String? subtitle,
    bool isLocked = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: iconAsset != null
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          iconAsset,
                          width: 22,
                          height: 22,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Icon(
                      icon!,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                  if (isLocked) ...[
                    const SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.lock,
                      color: Colors.grey.shade400,
                      size: 14,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
