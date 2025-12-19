import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/location_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'dart:async';

class LocationSuggestionsField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String hintText;
  final TextStyle? style;
  final InputDecoration? decoration;
  final Function(String)? onLocationSelected;
  final Function(LocationSuggestion)? onLocationSuggestionSelected;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final dynamic themeColors;

  const LocationSuggestionsField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    this.style,
    this.decoration,
    this.onLocationSelected,
    this.onLocationSuggestionSelected,
    this.onChanged,
    this.onTap,
    this.themeColors,
  });

  @override
  _LocationSuggestionsFieldState createState() =>
      _LocationSuggestionsFieldState();
}

class _LocationSuggestionsFieldState extends State<LocationSuggestionsField> {
  List<LocationSuggestion> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  Timer? _debounceTimer;
  Timer? _loadingTimeoutTimer;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    widget.controller.removeListener(_onControllerChanged);
    _debounceTimer?.cancel();
    _loadingTimeoutTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onControllerChanged() {
    if (_isLoading && widget.controller.text.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _isLoading) {
          setState(() {
            _isLoading = false;
            _showSuggestions = false;
          });
          _updateOverlay();
        }
      });
    }
  }

  void _onFocusChanged() {
    if (widget.focusNode.hasFocus) {
      if (_isLoading) {
        _showOverlay();
        return;
      }
      if (widget.controller.text.isEmpty) {
        _loadCurrentLocationSuggestions('');
        setState(() {
          _isLoading = false;
        });
      } else if (widget.controller.text.length > 2) {
        _searchLocations(widget.controller.text);
      }
      _showOverlay();
    } else {
      _debounceTimer?.cancel();
      _loadingTimeoutTimer?.cancel();
      setState(() {
        _isLoading = false;
        _showSuggestions = false;
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          _removeOverlay();
        }
      });
    }
  }

  void _loadCurrentLocationSuggestions(String query) async {
    setState(() {
      _isLoading = true;
    });
    _loadingTimeoutTimer?.cancel();
    _loadingTimeoutTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _showSuggestions = false;
        });
        _updateOverlay();
      }
    });
    _updateOverlay();

    try {
      final currentLocation = await LocationService.getCurrentLocation();
      if (currentLocation != null) {
        final currentAddress = await LocationService.getAddressFromCoordinates(
          currentLocation['latitude']!,
          currentLocation['longitude']!,
        );
        
        final nearbyPlaces = await LocationService.searchNearbyPlaces(
          query.isEmpty ? '' : query,
          lat: currentLocation['latitude'],
          lon: currentLocation['longitude'],
          limit: 7, 
        );

        if (mounted) {
          _loadingTimeoutTimer?.cancel();
          
          final suggestions = <LocationSuggestion>[];
          
          if (currentAddress != null) {
            suggestions.add(LocationSuggestion(
              name: 'Current Location',
              fullAddress: currentAddress['fullAddress'] ?? '',
              city: currentAddress['city'] ?? '',
              state: currentAddress['state'] ?? '',
              country: currentAddress['country'] ?? '',
              postalCode: currentAddress['postalCode'] ?? '',
              latitude: currentLocation['latitude'],
              longitude: currentLocation['longitude'],
            ));
          }
          
          suggestions.addAll(nearbyPlaces);

          setState(() {
            _suggestions = suggestions;
            _isLoading = false;
            _showSuggestions = suggestions.isNotEmpty;
          });
          _updateOverlay();
        }
      } else {
        if (mounted) {
          _loadingTimeoutTimer?.cancel();
          setState(() {
            _isLoading = false;
            _showSuggestions = false;
          });
        }
      }
    } catch (e) {
      logError('Error loading current location suggestions: $e');
      if (mounted) {
        _loadingTimeoutTimer?.cancel();
        setState(() {
          _isLoading = false;
          _showSuggestions = false;
        });
      }
    }
  }

  void _searchLocations(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 200), () async {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
      });

      try {
        final suggestions =
            await LocationService.getNearbyAreaSuggestions(query);

        if (mounted) {
          setState(() {
            _suggestions = suggestions;
            _isLoading = false;
            _showSuggestions = suggestions.isNotEmpty;
          });
          _updateOverlay();
        }
      } catch (e) {
        logError('Error searching locations: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showSuggestions = false;
          });
        }
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getTextFieldWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 56.0),
          child: ProjectConfig.appType == AppType.opw 
            ? Material(
                color: Colors.transparent,
                elevation: 0,
                child: _buildSuggestionsWidget(),
              )
            : Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: _buildSuggestionsWidget(),
              ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _getTextFieldWidth() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 300.0;
  }

  Widget _buildSuggestionsWidget() {
    if (_isLoading) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_showSuggestions || _suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: ProjectConfig.appType == AppType.opw 
        ? BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 8,
                offset: const Offset(0, -1),
                spreadRadius: 0,
              ),
            ],
          )
        : BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ProjectConfig.appType == AppType.opw ? 12.0 : 8.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = _suggestions[index];
            return _buildSuggestionTile(suggestion);
          },
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(LocationSuggestion suggestion) {
    final isCurrentLocation = suggestion.name == 'Current Location';
    final isOpwApp = ProjectConfig.appType == AppType.opw;
    
    return InkWell(
      onTap: () => _selectSuggestion(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isCurrentLocation 
            ? (widget.themeColors?.primary ?? Colors.blue).withOpacity(isOpwApp ? 0.1 : 0.05) 
            : null,
          border: Border(
            bottom: BorderSide(
              color: isOpwApp 
                ? Colors.white.withOpacity(0.3) 
                : Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isCurrentLocation ? Icons.my_location : Icons.location_on,
              color: widget.themeColors?.primary ?? Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isOpwApp ? Colors.black87 : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (suggestion.subtitle.isNotEmpty)
                    Text(
                      suggestion.subtitle,
                      style: TextStyle(
                        color: isOpwApp ? Colors.black54 : Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectSuggestion(LocationSuggestion suggestion) {
    String displayText = suggestion.displayName;
    if (suggestion.name == 'Current Location') {
      displayText = suggestion.city.isNotEmpty 
          ? suggestion.city 
          : (suggestion.fullAddress.isNotEmpty 
              ? suggestion.fullAddress 
              : suggestion.displayName);
    }
    
    setState(() {
      _showSuggestions = false;
    });
    _removeOverlay();
    
    Future.microtask(() {
      widget.controller.text = displayText;
      widget.onLocationSelected?.call(displayText);
      widget.onLocationSuggestionSelected?.call(suggestion);
      widget.onChanged?.call(displayText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: widget.style,
        decoration: widget.decoration ??
            InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.location_on),
            ),
        onTap: () {
          widget.onTap?.call();
          if (!widget.focusNode.hasFocus) {
            widget.focusNode.requestFocus();
          }
        },
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (value.isNotEmpty) {
            _searchLocations(value);
          } else if (value.isEmpty) {
            _loadCurrentLocationSuggestions('');
          } else {
            setState(() {
              _showSuggestions = false;
            });
            _updateOverlay();
          }
        },
      ),
    );
  }
}
