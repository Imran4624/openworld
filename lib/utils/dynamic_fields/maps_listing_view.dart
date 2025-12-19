import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'dart:ui' as ui;

final List<Product> products = [
  Product(
    id: '1',
    title: 'Modern Studio in Central London',
    price: 1800,
    location: const LatLng(51.5131, -0.1021),
    imageUrl: 'https://picsum.photos/300/200?random=1',
  ),
  Product(
    id: '2',
    title: 'Luxury 2-Bed Apartment Chelsea',
    price: 3200,
    location: const LatLng(51.4875, -0.1689),
    imageUrl: 'https://picsum.photos/300/200?random=2',
  ),
  Product(
    id: '3',
    title: 'Designer Loft Shoreditch',
    price: 2200,
    location: const LatLng(51.5253, -0.0756),
    imageUrl: 'https://picsum.photos/300/200?random=3',
  ),
  Product(
    id: '4',
    title: 'Riverside Flat Canary Wharf',
    price: 2800,
    location: const LatLng(51.5054, -0.0235),
    imageUrl: 'https://picsum.photos/300/200?random=4',
  ),
  Product(
    id: '5',
    title: 'Victorian House Room Notting Hill',
    price: 1250,
    location: const LatLng(51.5112, -0.2055),
    imageUrl: 'https://picsum.photos/300/200?random=5',
  ),
  Product(
    id: '6',
    title: 'Executive Studio City of London',
    price: 1950,
    location: const LatLng(51.5155, -0.0723),
    imageUrl: 'https://picsum.photos/300/200?random=6',
  ),
  Product(
    id: '7',
    title: 'Penthouse View Mayfair',
    price: 4500,
    location: const LatLng(51.5104, -0.1554),
    imageUrl: 'https://picsum.photos/300/200?random=7',
  ),
  Product(
    id: '8',
    title: 'Modern Flat Camden Town',
    price: 1600,
    location: const LatLng(51.5393, -0.1434),
    imageUrl: 'https://picsum.photos/300/200?random=8',
  ),
  Product(
    id: '9',
    title: 'Chic Studio South Bank',
    price: 1750,
    location: const LatLng(51.5048, -0.0875),
    imageUrl: 'https://picsum.photos/300/200?random=9',
  ),
  Product(
    id: '10',
    title: 'Luxury Studio Kensington',
    price: 2100,
    location: const LatLng(51.4993, -0.1937),
    imageUrl: 'https://picsum.photos/300/200?random=10',
  ),
  Product(
    id: '11',
    title: 'Artist Studio Soho',
    price: 1650,
    location: const LatLng(51.5137, -0.1337),
    imageUrl: 'https://picsum.photos/300/200?random=11',
  ),
  Product(
    id: '12',
    title: 'Modern Room Paddington',
    price: 1450,
    location: const LatLng(51.5159, -0.1757),
    imageUrl: 'https://picsum.photos/300/200?random=12',
  ),
  Product(
    id: '13',
    title: 'Designer Flat Bloomsbury',
    price: 2300,
    location: const LatLng(51.5217, -0.1281),
    imageUrl: 'https://picsum.photos/300/200?random=13',
  ),
  Product(
    id: '14',
    title: 'Luxury Studio Greenwich',
    price: 1550,
    location: const LatLng(51.4809, -0.0053),
    imageUrl: 'https://picsum.photos/300/200?random=14',
  ),
  Product(
    id: '15',
    title: 'City View Studio Tower Bridge',
    price: 2100,
    location: const LatLng(51.5045, -0.0755),
    imageUrl: 'https://picsum.photos/300/200?random=15',
  ),
  Product(
    id: '16',
    title: 'Modern Apartment Fitzrovia',
    price: 2450,
    location: const LatLng(51.5199, -0.1395),
    imageUrl: 'https://picsum.photos/300/200?random=16',
  ),
  Product(
    id: '17',
    title: 'Boutique Studio Marylebone',
    price: 1950,
    location: const LatLng(51.5202, -0.1583),
    imageUrl: 'https://picsum.photos/300/200?random=17',
  ),
  Product(
    id: '18',
    title: 'Executive Room Bank',
    price: 2650,
    location: const LatLng(51.5134, -0.0889),
    imageUrl: 'https://picsum.photos/300/200?random=18',
  ),
  Product(
    id: '19',
    title: 'Charming Studio Covent Garden',
    price: 1850,
    location: const LatLng(51.5129, -0.1243),
    imageUrl: 'https://picsum.photos/300/200?random=19',
  ),
  Product(
    id: '20',
    title: 'Luxury Loft Battersea',
    price: 3100,
    location: const LatLng(51.4794, -0.1494),
    imageUrl: 'https://picsum.photos/300/200?random=20',
  ),
];

class Product {
  final String id;
  final String title;
  final double price;
  final LatLng location;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
  });
}

class MapListingScreen extends StatefulWidget {
  static const String route = '/map-listing';
  @override
  _MapListingScreenState createState() => _MapListingScreenState();
}

class _MapListingScreenState extends State<MapListingScreen> {
  final ScrollController _scrollController = ScrollController();
  LatLng? _selectedMarkerPosition;
  CameraPosition? _lastCameraPosition;

  late GoogleMapController mapController;
  late final Completer<GoogleMapController> _controller = Completer();
  bool _isMapReady = false;
  Product? selectedProduct;
  Offset? _popupPosition;
  bool _isMapExpanded = true;

  @override
  void dispose() {
    mapController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<BitmapDescriptor> _createMarkerImage(String price) async {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$$price',
        style: TextStyle(
          color: AppTheme.dark.text,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const padding = 8.0;
    const radius = 8.0;
    final width = textPainter.width + padding * 2;
    final height = textPainter.height + padding * 2;

    final Paint paint = Paint()
      ..color = appTheme.primary
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(radius),
      ),
      paint,
    );

    textPainter.paint(canvas, const Offset(padding, padding));

    final image = await pictureRecorder.endRecording().toImage(
          width.ceil(),
          height.ceil(),
        );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
    mapController = controller;
    _isMapReady = true;
  }

  Future<void> _goToLocation(LatLng position) async {
    if (!_isMapReady) return;

    try {
      final GoogleMapController controller = await _controller.future;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
          ),
        ),
      );

      // For smoother transition, add a small delay before recentering
      await Future.delayed(const Duration(milliseconds: 300));
      await controller.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    } catch (e) {
      logError(' Error moving camera: $e');
    }
  }

  void _toggleMapExpansion() {
    setState(() {
      _isMapExpanded = !_isMapExpanded;
    });
  }

  Widget _buildPropertyList() {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          key: Key(product.id),
          child: InkWell(
            onTap: () {
              if (!_isMapReady) return;
              setState(() {
                selectedProduct = product;
                _popupPosition = null;
              });
              _goToLocation(product.location);
            },
            child: Card(
              color: selectedProduct?.id == product.id
                  ? appTheme.background
                  : appTheme.secondary,
              margin: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.network(
                    product.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(fontSize: 16),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${product.price}/month',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
        );
      },
    );
  }

  Widget _buildMap() {
    return FutureBuilder<List<Marker>>(
      future: _createMarkers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: products.first.location,
            zoom: 12.0,
          ),
          markers: Set<Marker>.of(snapshot.data!),
          onTap: (_) => setState(() => _popupPosition = null),
          onCameraMove: (position) => _lastCameraPosition = position,
        );
      },
    );
  }

  Future<List<Marker>> _createMarkers() async {
    List<Marker> markers = [];

    for (var product in products) {
      final markerIcon =
          await _createMarkerImage(product.price.toStringAsFixed(0));
      markers.add(
        Marker(
          markerId: MarkerId(product.id),
          position: product.location,
          icon: markerIcon,
          onTap: () async {
            // First perform async operations
            final screenPosition =
                await mapController.getScreenCoordinate(product.location);
            final offset = MediaQuery.of(context).size;
            final zoomLevel = await mapController.getZoomLevel();

            // Then update state synchronously
            setState(() {
              selectedProduct = product;
              _selectedMarkerPosition = product.location;
              _popupPosition = Offset(
                screenPosition.x.toDouble().clamp(100, offset.width - 200),
                screenPosition.y.toDouble().clamp(120, offset.height - 200),
              );
              _lastCameraPosition = CameraPosition(
                target: product.location,
                zoom: zoomLevel,
              );
            });
          },
        ),
      );
    }
    return markers;
  }

  void _updatePopupPosition() async {
    if (_selectedMarkerPosition == null || _lastCameraPosition == null) return;

    // First get async data
    final screenPosition =
        await mapController.getScreenCoordinate(_selectedMarkerPosition!);
    final offset = MediaQuery.of(context).size;

    // Then update state
    setState(() {
      _popupPosition = Offset(
        screenPosition.x.toDouble().clamp(100, offset.width - 200),
        screenPosition.y.toDouble().clamp(120, offset.height - 200),
      );
    });
  }

  Widget _buildMapPopup() {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
    return Listener(
        onPointerDown: (_) {}, // Capture pointer events
        child: GestureDetector(
          behavior: HitTestBehavior.opaque, // Make entire popup tappable
          onTap: () {}, // Absorb taps
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    selectedProduct!.imageUrl,
                    width: 200,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedProduct!.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _scrollToSelectedItem();
                        setState(() =>
                            _popupPosition = null); // Close popup after click
                      },
                      child: Text(
                        '\$${selectedProduct!.price}/month',
                        style: TextStyle(
                          fontSize: 16,
                          color: appTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _scrollToSelectedItem() {
    final index = products.indexWhere((p) => p.id == selectedProduct?.id);
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          (index * 166.0), // Adjust based on your item height
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final mapFlex = isWeb() ? 5 : 6;
    final listFlex = isWeb() ? 5 : 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Listings'),
        actions: isMobile
            ? [
                TextButton.icon(
                  onPressed: _toggleMapExpansion,
                  icon: Icon(
                    _isMapExpanded ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.grey,
                  ),
                  label: Text(
                    _isMapExpanded ? "Hide Map" : "Show Map",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                )
              ]
            : null,
      ),
      body: Stack(
        children: [
          if (isMobile)
            Column(
              children: [
                if (_isMapExpanded) Expanded(child: _buildMap()),
                Expanded(child: _buildPropertyList()),
              ],
            )
          else
            Row(
              children: [
                Expanded(flex: mapFlex, child: _buildMap()),
                Expanded(flex: listFlex, child: _buildPropertyList()),
              ],
            ),
          if (_popupPosition != null && selectedProduct != null)
            Positioned(
              left: _popupPosition!.dx,
              top: _popupPosition!.dy - 140, // Extra space above marker
              child: IgnorePointer(
                ignoring: false,
                child: AbsorbPointer(
                  child: _buildMapPopup(),
                ),
              ),
            ),
          if (_lastCameraPosition != null)
            Positioned(
              right: 20,
              bottom: 20,
              child: IconButton(
                icon: const Icon(Icons.gps_fixed),
                onPressed: _updatePopupPosition,
                tooltip: 'Recenter popup',
              ),
            ),
        ],
      ),
    );
  }
}
