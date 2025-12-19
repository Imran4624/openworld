import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/static_top_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

class WelcomeEventScreen extends StatelessWidget {
  const WelcomeEventScreen({Key? key}) : super(key: key);

  static const String route = '/welcome-event';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _WelcomeEventScreenModel>(
      converter: (store) => _WelcomeEventScreenModel.fromStore(store.state),
      builder: (context, vm) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isMobile = screenWidth < kMobileLayoutWidth;
        final isTablet = screenWidth >= kMobileLayoutWidth &&
            screenWidth < kTabletLayoutWidth;
        final isWide = screenWidth >= kTabletLayoutWidth;
        final themeColors = vm.themeColors;
        return Scaffold(
          backgroundColor: themeColors.background,
          body: isMobile || isTablet
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              'assets/loopjam/images/welcom_screen_mobile_image.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: screenHeight * 0.42,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Share Your Day.',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: themeColors.text,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeColors.textSecondary,
                                    ),
                                    children: [
                                      const TextSpan(
                                      text: 'Photos and videos in one place. '),
                                      TextSpan(
                                        text: 'Free to use.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: themeColors.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 22),
                                SizedBox(
                                  width: 180,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      createEntityByType(
                                        context: context,
                                        entityType: EntityType.event,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeColors.primary,
                                      foregroundColor: themeColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                    ),
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Start an event',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: themeColors.secondary,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.navigate_next_outlined,
                                            color: themeColors.secondary,
                                            size: isMobile ? 20 : 24),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text(
                                      'Already have an event? ',
                                      style: TextStyle(
                                        color: themeColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LoginDialogView(
                                              onClose: () {
                                                Navigator.of(context).pop();
                                              },
                                              onLoginSuccess: () {
                                                Navigator.of(context).pop();
                                                // Handle successful login from welcome screen
                                              },
                                              isDialogLogin: false,
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                          color: themeColors.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(3, (i) {
                                    final stepTitles = [
                                      'Create an event',
                                      'Add guests',
                                      'Relive the day',
                                    ];
                                    final stepSubtitles = [
                                      'Generate a unique page for your guests.',
                                      'Share event link, guests upload, no app needed.',
                                      'All photos and videos appear in one place.',
                                    ];
                                    return Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: themeColors.primary
                                                .withOpacity(0.50),
                                            child: Text(
                                              '${i + 1}',
                                              style: TextStyle(
                                                color: themeColors.text,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            stepTitles[i],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: themeColors.text,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            stepSubtitles[i],
                                            style: TextStyle(
                                              color: themeColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: isTablet ? 20 : 0,
                      left: 0,
                      right: 0,
                      child: const StaticTopBar(),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/loopjam/images/welcom_screen_image.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 60 : 24),
                            child: _buildContent(context, vm, isMobile, isWide),
                          ),
                        ),
                      ],
                    ),
                    
                    const Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: StaticTopBar(),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, _WelcomeEventScreenModel vm,
      bool isMobile, bool isWide) {
    final themeColors = vm.themeColors;
    final stepTitles = [
      'Create an event',
      'Add guests',
      'Relive the day',
    ];
    final stepSubtitles = [
      'Generate a unique page for your guests.',
      'Share event link, guests upload, no app needed.',
      'All photos and videos appear in one place.',
    ];
    return Column(
      children: [
        // Main content area
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share Your Day.',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 48,
                      fontWeight: FontWeight.bold,
                      color: themeColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        'Photos and videos in one place. ',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 22,
                          color: themeColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Free to use.',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 22,
                          color: themeColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 24 : 36),
                  SizedBox(
                    width: isMobile ? double.infinity : 180,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        createEntityByType(
                          context: context,
                          entityType: EntityType.event,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColors.primary,
                        foregroundColor: themeColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Start an event',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: themeColors.secondary,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.navigate_next_outlined,
                              color: themeColors.secondary,
                              size: isMobile ? 20 : 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Three steps at bottom center for web view
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  3,
                  (i) => Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                themeColors.primary.withOpacity(0.50),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: themeColors.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            stepTitles[i],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: themeColors.text,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 140,
                            child: Text(
                              stepSubtitles[i],
                              style: TextStyle(
                                color: themeColors.textSecondary,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )),
            ),
          ),
      ],
    );
  }
}

class _WelcomeEventScreenModel {
  final ThemeColors themeColors;
  final bool isDarkMode;
  _WelcomeEventScreenModel(
      {required this.themeColors, required this.isDarkMode});

  factory _WelcomeEventScreenModel.fromStore(AppState state) {
    final isDarkMode = state.prefState.enableDarkMode;
    final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;
    return _WelcomeEventScreenModel(
        themeColors: themeColors, isDarkMode: isDarkMode);
  }
}
