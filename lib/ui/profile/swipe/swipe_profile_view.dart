import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/ui/profile/swipe/swipe_card.dart';


import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_redux/flutter_redux.dart';

enum SwipeDirection { left, right }

class SwipeProfileView extends StatefulWidget {
  final List<String> profileList;
  final Map<String, ProfileEntity> profileMap;
  final VoidCallback? onRefresh;
  final AppState state;

  const SwipeProfileView({
    super.key,
    required this.profileList,
    required this.profileMap,
    this.onRefresh,
    required this.state,
  });

  @override
  State<SwipeProfileView> createState() => _SwipeProfileViewState();
}

class _SwipeProfileViewState extends State<SwipeProfileView>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  bool _isDragging = false;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _checkAndLoadMoreProfiles();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkAndLoadMoreProfiles() {
    final remainingProfiles = widget.profileList.length - _currentIndex;
    
    if (remainingProfiles <= 2 && widget.profileList.isNotEmpty) {
      _loadMoreProfiles();
    }
  }

  void _loadMoreProfiles() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final completer = snackBarCompleter<void>('Loading more profiles...');
    
    store.dispatch(LoadProfiles(
      completer: completer,
      filter: store.state.profileState.filter,
    ));
  }

  void _performPassAction() {
    if (_currentIndex < widget.profileList.length) {
      final profileId = widget.profileList[_currentIndex];
      final store = StoreProvider.of<AppState>(context, listen: false);
      
      if (ProjectConfig.canUserPassProfiles) {
        final completer = snackBarCompleter<void>('Passed');
        store.dispatch(PassProfileRequest(
          completer: completer,
          targetUserId: profileId,
        ));
      }
    }
  }

  void _performLikeAction() {
    if (_currentIndex < widget.profileList.length) {
      final profileId = widget.profileList[_currentIndex];
      final store = StoreProvider.of<AppState>(context, listen: false);
      
      final completer = snackBarCompleter<void>(ProjectConfig.likeOrWaveRequestSent);
      store.dispatch(LikeProfileRequest(
        completer: completer,
        targetUserId: profileId,
        type: LikeType.normal,
      ));
    }
  }

  void _onSwipeLeft() {
    if (_currentIndex < widget.profileList.length) {
      HapticFeedback.lightImpact();
      
      _performPassAction();
      _moveToNextProfileWithAnimation(SwipeDirection.left);
    }
  }

  void _onSwipeRight() {
    if (_currentIndex < widget.profileList.length) {
      HapticFeedback.mediumImpact();
      
      _performLikeAction();
      _moveToNextProfileWithAnimation(SwipeDirection.right);
    }
  }

  void _moveToNextProfileWithAnimation(SwipeDirection direction) {
    _animateCardAwayInDirection(direction).then((_) {
      setState(() {
        _currentIndex++;
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
      
      _checkAndLoadMoreProfiles();
      
      if (_currentIndex >= widget.profileList.length) {
        _showNoMoreProfilesDialog();
      }
    });
  }



  Future<void> _animateCardAwayInDirection(SwipeDirection direction) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final initialOffset = direction == SwipeDirection.right
        ? Offset(screenWidth * 0.15, -20)
        : Offset(-screenWidth * 0.15, -20);
    
    setState(() {
      _dragOffset = initialOffset;
      _isDragging = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    
    final targetOffset = direction == SwipeDirection.right
        ? Offset(screenWidth * 1.5, screenHeight * 0.1)
        : Offset(-screenWidth * 1.5, screenHeight * 0.1);
    
    setState(() {
      _dragOffset = targetOffset;
    });
    
    await Future.delayed(const Duration(milliseconds: 600));
  }



  void _showNoMoreProfilesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No More Profiles'),
          content: const Text('You\'ve seen all available profiles. Check back later for more!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onRefresh != null) {
                  widget.onRefresh!();
                }
              },
              child: const Text('Refresh'),
            ),
          ],
        );
      },
    );
  }

  void _onCardTap() {
    if (_currentIndex < widget.profileList.length) {
      final profileId = widget.profileList[_currentIndex];
      final store = StoreProvider.of<AppState>(context, listen: false);
      
      store.dispatch(ViewProfile(profileId: profileId));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profileList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No profiles to show',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for more profiles!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_currentIndex >= widget.profileList.length) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'You\'ve seen all profiles!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for more.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            // Card stack
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _isDragging = true;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _dragOffset += details.delta;
                  });
                },
                onPanEnd: (details) {
                  final threshold = MediaQuery.of(context).size.width * 0.3;
                  
                  if (_dragOffset.dx.abs() > threshold) {
                    final direction = _dragOffset.dx > 0 ? SwipeDirection.right : SwipeDirection.left;
                    if (direction == SwipeDirection.right) {
                      _performLikeAction();
                    } else {
                      _performPassAction();
                    }
                    _moveToNextProfileWithAnimation(direction);
                  } else {
                    setState(() {
                      _dragOffset = Offset.zero;
                      _isDragging = false;
                    });
                  }
                },
                child: Stack(
                  children: [
                    for (int i = min(_currentIndex + 2, widget.profileList.length - 1);
                         i >= _currentIndex && i < widget.profileList.length;
                         i--)
                      _buildCard(i),
                  ],
                ),
              ),
            ),
            
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (ProjectConfig.canUserPassProfiles)
                    FloatingActionButton(
                      onPressed: _onSwipeLeft,
                      backgroundColor: Colors.red,
                      heroTag: "pass",
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  
                  FloatingActionButton(
                    onPressed: _onSwipeRight,
                    backgroundColor: Colors.green,
                    heroTag: "like",
                    child: Icon(
                      ProjectConfig.likeOrWaveIcon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    final profileId = widget.profileList[index];
    final profile = widget.profileMap[profileId];
    
    if (profile == null) {
      return Container(); 
    }

    final isTopCard = index == _currentIndex;
    final cardIndex = index - _currentIndex;
    final scale = 1.0 - (cardIndex * 0.05);
    final yOffset = cardIndex * 10.0;

    return Positioned(
      top: yOffset,
      left: 20 + (cardIndex * 5),
      right: 20 + (cardIndex * 5),
      bottom: 150 + yOffset,
      child: Transform.scale(
        scale: scale,
        child: SwipeCard(
          profile: profile,
          onTap: isTopCard ? _onCardTap : null,
          isDragging: isTopCard ? _isDragging : false,
          dragOffset: isTopCard ? _dragOffset : Offset.zero,
          onLike: isTopCard ? _onSwipeRight : null,
          onPass: isTopCard ? _onSwipeLeft : null,
        ),
      ),
    );
  }
}
