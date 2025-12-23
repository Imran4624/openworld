// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:intl/intl.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/utils/font_utils.dart';

class StaticTopBar extends StatelessWidget {
  const StaticTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      distinct: true,
      converter: (store) => store.state,
      builder: (context, state) {
        final themeColors =
            AppTheme.getThemeColors(state.prefState.enableDarkMode);

        if (isMobile(context)) {
          return Material(
            color: Colors.transparent,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: MediaQuery.of(context).padding.top + 8.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isAuthenticated(state) == true) {
                                RoutingRules.defaultEntityLoadingRouting();
                              } else {
                                showDialog(
                                  context: navigatorKey.currentContext!,
                                  builder: (BuildContext context) {
                                    return LoginDialogView(
                                      onClose: () {
                                        Navigator.of(context).pop();
                                      },
                                      onLoginSuccess: () {
                                        Navigator.of(context).pop();
                                      },
                                      isDialogLogin: false,
                                    );
                                  },
                                );
                              }
                            },
                            child: Image.asset(
                              ProjectConfig.logoPath(
                                  state.prefState.enableDarkMode),
                              height: 32,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isAuthenticated(state)
                        ? _LoopjamUserSelector()
                        : SizedBox(
                            height: 38,
                            child: OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: navigatorKey.currentContext!,
                                  builder: (BuildContext context) {
                                    return LoginDialogView(
                                      onClose: () {
                                        Navigator.of(context).pop();
                                      },
                                      onLoginSuccess: () {
                                        Navigator.of(context).pop();
                                      },
                                      isDialogLogin: false,
                                    );
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: themeColors.primary,
                                side: BorderSide(
                                    color: Colors.grey.shade300, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              child: Text(
                                'Sign in',
                                style: FontUtils.getTextStyleWithFont(
                                  fontFamily: 'Outfit',
                                  baseStyle: TextStyle(
                                    color: themeColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            printL(
                                'isAuthenticated(state) ==> ${isAuthenticated(state)}');
                            if (isAuthenticated(state) == true) {
                              RoutingRules.defaultEntityLoadingRouting();
                            } else {
                              showDialog(
                                context: navigatorKey.currentContext!,
                                builder: (BuildContext context) {
                                  return LoginDialogView(
                                    onClose: () {
                                      Navigator.of(context).pop();
                                    },
                                    onLoginSuccess: () {
                                      Navigator.of(context).pop();
                                    },
                                    isDialogLogin: false,
                                  );
                                },
                              );
                            }
                          },
                          child: Image.asset(
                            ProjectConfig.logoPath(
                                state.prefState.enableDarkMode),
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Spacer(),
                        isAuthenticated(state)
                            ? _LoopjamUserSelector()
                            : SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: navigatorKey.currentContext!,
                                      builder: (BuildContext context) {
                                        return LoginDialogView(
                                          onClose: () {
                                            Navigator.of(context).pop();
                                          },
                                          onLoginSuccess: () {
                                            Navigator.of(context).pop();
                                          },
                                          isDialogLogin: false,
                                        );
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: themeColors.primary,
                                    side: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 26, vertical: 8),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  child: Text(
                                    'Sign in',
                                    style: FontUtils.getTextStyleWithFont(
                                      fontFamily: 'Outfit',
                                      baseStyle: TextStyle(
                                        color: themeColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class _LoopjamUserSelector extends StatefulWidget {
  @override
  State<_LoopjamUserSelector> createState() => _LoopjamUserSelectorState();
}

class _LoopjamUserSelectorState extends State<_LoopjamUserSelector> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showPopup(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final isAuth = isAuthenticated(state);
    final themeColors = AppTheme.getThemeColors(state.prefState.enableDarkMode);

    final userName = isAuth
        ? state.authState.currentUserName.isNotEmpty
            ? state.authState.currentUserName
            : state.user.firstName
        : 'Guest User';

    String joinDate = 'Joined Recently';
    if (isAuth) {
      try {
        final createdAt = state.profileState.loggedInUserProfile.createdAt;
        if (createdAt > 0) {
          final date = DateTime.fromMillisecondsSinceEpoch(createdAt);
          final formatter = DateFormat('MMMM y');
          joinDate = 'Joined ${formatter.format(date)}';
        }
      } catch (e) {
        joinDate = 'Joined Recently';
      }
    }

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hidePopup,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                    isMobile(context)
                        ? -220
                        : isDesktop(context)
                            ? -180
                            : -120,
                    28),
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: themeColors.text.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            const _UserAvatar(size: 40),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: themeColors.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: themeColors.text,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (isAuth) ...[
                              GestureDetector(
                                onTap: () {
                                  _hidePopup();
                                  _onMenuSelected(
                                      context, DrawerActions.deleteAccount);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: themeColors.outline),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: 14,
                                        color: themeColors.danger,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Delete Account',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: themeColors.danger,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                joinDate,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: themeColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 70.0,
                      ),
                      if (isAuth) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              if (isAdmin(state))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 34,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _hidePopup();
                                        _onMenuSelected(context,
                                            DrawerActions.connectAccount);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeColors.secondary,
                                        foregroundColor: themeColors.primary,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                            color: themeColors.primary,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_balance,
                                            size: 16,
                                            color: themeColors.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Connect Account',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: themeColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              // Logout Button
                              SizedBox(
                                width: double.infinity,
                                height: 34,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _hidePopup();
                                    _onMenuSelected(
                                        context, DrawerActions.logout);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColors.primary,
                                    foregroundColor: themeColors.secondary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                  ),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: themeColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {
                                _hidePopup();
                                _onMenuSelected(context, DrawerActions.login);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColors.primary,
                                foregroundColor: themeColors.secondary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: FontUtils.getTextStyleWithFont(
                                  fontFamily: 'Outfit',
                                  baseStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: themeColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMenuSelected(BuildContext context, String value) {
    final store = StoreProvider.of<AppState>(context);
    if (value == DrawerActions.login) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoginDialogView(
            onClose: () {
              Navigator.of(context).pop();
            },
            onLoginSuccess: () {
              Navigator.of(context).pop();
            },
            isDialogLogin: false,
          );
        },
      );
    } else if (value == DrawerActions.logout) {
      store.dispatch(UserLogout());
    } else if (value == DrawerActions.editProfile) {
      logInfo('Edit Profile clicked');
    } else if (value == DrawerActions.connectAccount) {
    } else if (value == DrawerActions.deleteAccount) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext dialogContext) {
          String confirmText = '';
          String reason = '';

          return StatefulBuilder(
            builder: (builderContext, setState) {
              return AlertDialog(
                title: const Text('Delete Account'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Are you sure you want to delete your account? This action cannot be undone.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please type "delete" to confirm:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          confirmText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type "delete" here',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reason for deletion (optional):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          reason = value;
                        });
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter reason...',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: confirmText.toLowerCase() == 'delete'
                        ? () {
                            Navigator.pop(dialogContext);

                            final completer = Completer<Null>();

                            completer.future.then((_) {
                              ScaffoldMessenger.of(navigatorKey.currentContext!)
                                  .showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Account deleted successfully')),
                              );

                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                store.dispatch(UserLogout());
                              });
                            }).catchError((error) {
                              logError('Error purging profile: $error');
                              ScaffoldMessenger.of(navigatorKey.currentContext!)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Error deleting profile: $error'),
                                ),
                              );
                            });

                            if (reason.isNotEmpty) {
                              logInfo('Account deletion reason: $reason');
                            }

                            store.dispatch(PurgeProfilesRequest(
                              completer,
                              [getLoggedInUserId(store)].toList(),
                              true,
                            ));
                          }
                        : null,
                    child: const Text('DELETE'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () => _showPopup(context),
        child: const _UserAvatar(size: 40),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final double size;
  const _UserAvatar({this.size = 25});

  bool _isNetworkUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    printL('url: $url');
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Widget _buildImage(String imagePath, double size) {
    if (_isNetworkUrl(imagePath)) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          printL('Loading placeholder for: $url');
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorWidget: (context, url, error) {
          return Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person),
              );
            },
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: SizedBox(
          width: size,
          height: size,
          child: _buildImage(
            state.profileState.loggedInUserProfile.dynamicFields['images']
                    ?.first ??
                ProjectConfig.defaultUserIcon,
            size,
          ),
        ),
      ),
    );
  }
}
