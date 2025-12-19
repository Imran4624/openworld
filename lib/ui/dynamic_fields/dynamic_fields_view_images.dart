import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/project_config.dart';

class DynamicFieldsViewImages extends StatefulWidget {
  final ImageViewType viewType;
  final List<String> images;
  final List<String?>? titles;
  final List<String?>? descriptions;
  final Function(int)? onPageChanged;
  final int? currentIndex;
  final double blurIntensity;
  final bool showNextImageButton;

  const DynamicFieldsViewImages({
    Key? key,
    required this.viewType,
    required this.images,
    this.titles,
    this.descriptions,
    this.onPageChanged,
    this.currentIndex,
    this.showNextImageButton = false,
    this.blurIntensity = ProjectConfig.defaultBlurIntensity,
  }) : super(key: key);

  @override
  _DynamicFieldsViewImagesState createState() =>
      _DynamicFieldsViewImagesState();
}

class _DynamicFieldsViewImagesState extends State<DynamicFieldsViewImages> {
  late int _currentIndex;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
  }

  @override
  void didUpdateWidget(DynamicFieldsViewImages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != null &&
        widget.currentIndex != oldWidget.currentIndex) {
      _currentIndex = widget.currentIndex!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_carouselController.ready) {
          _carouselController.jumpToPage(_currentIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    switch (widget.viewType) {
      case ImageViewType.thumbnailBig:
        return _buildThumbnailBig();
      case ImageViewType.detail:
        return _buildDetailView();
      case ImageViewType.thumbnail:
      default:
        // Thumbnail view not implemented yet
        return const SizedBox.shrink();
    }
  }

  Widget _buildThumbnailBig() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onTap: () => _openFullScreenImage(widget.images, _currentIndex),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.images.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 40),
                ),
              ),
              if (ProjectConfig.blurImagesByDefault)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blurIntensity,
                        sigmaY: widget.blurIntensity,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    final Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: CarouselSlider(
            items: widget.images.map((imageUrl) {
              return widget.showNextImageButton
                  ? Stack(
                      children: [
                        SizedBox(
                          width: screenSize.width,
                          height: screenSize.height,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error, color: Colors.red, size: 40),
                            ),
                          ),
                        ),
                        if (ProjectConfig.blurImagesByDefault)
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: widget.blurIntensity,
                                sigmaY: widget.blurIntensity,
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () => _openFullScreenImage(widget.images, _currentIndex),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: screenSize.width,
                            height: screenSize.height,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.error, color: Colors.red, size: 40),
                              ),
                            ),
                          ),
                          if (ProjectConfig.blurImagesByDefault)
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: widget.blurIntensity,
                                  sigmaY: widget.blurIntensity,
                                ),
                                child: Container(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
            }).toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              height: screenSize.height,
              viewportFraction: 1.0,
              initialPage: _currentIndex,
              enableInfiniteScroll: false,
              autoPlay: false, 
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _currentIndex = index;
                  });
                  if (widget.onPageChanged != null) {
                    widget.onPageChanged!(index);
                  }
                });
              },
            ),
          ),
        ),
        if (_hasTextForCurrentSlide())
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_getCurrentTitle()?.isNotEmpty == true)
                    Text(
                      _getCurrentTitle()!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (_getCurrentTitle()?.isNotEmpty == true &&
                      _getCurrentDescription()?.isNotEmpty == true)
                    const SizedBox(height: 8),
                  if (_getCurrentDescription()?.isNotEmpty == true)
                    Text(
                      _getCurrentDescription()!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),

        if (widget.images.length > 1 && widget.showNextImageButton && _currentIndex < widget.images.length - 1)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_currentIndex < widget.images.length - 1) {
                    _carouselController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(
                          _currentIndex == entry.key ? 0.9 : 0.4,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool _hasTextForCurrentSlide() {
    return _getCurrentTitle()?.isNotEmpty == true ||
        _getCurrentDescription()?.isNotEmpty == true;
  }

  String? _getCurrentTitle() {
    if (widget.titles == null || _currentIndex >= widget.titles!.length) {
      return null;
    }
    return widget.titles![_currentIndex];
  }

  String? _getCurrentDescription() {
    if (widget.descriptions == null ||
        _currentIndex >= widget.descriptions!.length) {
      return null;
    }
    return widget.descriptions![_currentIndex];
  }

  void _openFullScreenImage(List<String> imageUrls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          isBlur: ProjectConfig.blurImagesByDefault,
          blurIntensity: widget.blurIntensity,
        ),
      ),
    );
  }
}

/// A full screen image viewer with gallery capabilities
class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final bool isBlur;
  final double blurIntensity;

  const FullScreenImageViewer({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
    this.isBlur = false,
    this.blurIntensity = 10.0,
  }) : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Set system overlays to create immersive experience
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
  }

  @override
  void dispose() {
    // Restore system overlays when done
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image view
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrls[index],
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error,
                                color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                      if (widget.isBlur)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: widget.blurIntensity,
                              sigmaY: widget.blurIntensity,
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 40,
            right: 60,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ),

          // Image counter
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '${_currentIndex + 1} / ${widget.imageUrls.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imageUrls.asMap().entries.map((entry) {
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Navigation arrows if multiple images
          if (widget.imageUrls.length > 1) ...[
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _currentIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                child: Container(
                  width: 60,
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: _currentIndex > 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.2),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _currentIndex < widget.imageUrls.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                child: Container(
                  width: 60,
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: _currentIndex < widget.imageUrls.length - 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.2),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
