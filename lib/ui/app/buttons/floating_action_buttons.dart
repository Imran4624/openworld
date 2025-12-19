import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/ui/photo/photo_edit_dialog.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:redux/redux.dart';

class FloatingActionButtons extends StatelessWidget {
  final Widget? child;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Object? heroTag;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final VoidCallback? onPressed;
  final MouseCursor? mouseCursor;
  final bool mini;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool isExtended;
  final bool? enableFeedback;
  final EntityType? entityType;
  // New optional buttons
  final bool showEditButton;
  final bool showLinkButton;
  final bool showLayoutButton;
  final bool showBackButton;
  final bool showAttendeesButton;
  final VoidCallback? onEdit;
  final VoidCallback? onLink;
  final VoidCallback? onLayout;
  final VoidCallback? onBack;
  final VoidCallback? onAttendees;

  const FloatingActionButtons({
    Key? key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    required this.onPressed,
    this.mouseCursor,
    this.mini = false,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.isExtended = false,
    this.enableFeedback,
    this.entityType,
    this.showEditButton = false,
    this.showLinkButton = false,
    this.showLayoutButton = false,
    this.showBackButton = false,
    this.showAttendeesButton = false,
    this.onEdit,
    this.onLink,
    this.onLayout,
    this.onBack,
    this.onAttendees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ThemeColors>(
      converter: (store) => AppTheme.getThemeColors(store.state.prefState.enableDarkMode),
      builder: (context, appTheme) {
        final List<Widget> centerButtons = [];
        if (showEditButton && onEdit != null) {
          centerButtons.add(_buildIconButton(
            context,
            icon: Icons.edit,
            tooltip: 'Edit',
            onPressed: onEdit,
            backgroundColor: Colors.white,
            foregroundColor: appTheme.primary,
          ));
        }
        if (showLinkButton && onLink != null) {
          centerButtons.add(_buildIconButton(
            context,
            icon: Icons.link,
            tooltip: 'Share',
            onPressed: onLink,
            backgroundColor: Colors.white,
            foregroundColor: appTheme.primary,
          ));
        }
        if (showLayoutButton && onLayout != null) {
          centerButtons.add(_buildIconButton(
            context,
            icon: Icons.view_agenda_outlined,
            tooltip: 'Layout',
            onPressed: onLayout,
            backgroundColor: Colors.white,
            foregroundColor: appTheme.primary,
          ));
        }
        if (showAttendeesButton && onAttendees != null) {
          centerButtons.add(_buildIconButton(
            context,
            icon: Icons.people,
            tooltip: 'Attendees',
            onPressed: onAttendees,
            backgroundColor: Colors.white,
            foregroundColor: appTheme.primary,
          ));
        }
        Widget? backButton;
        if (showBackButton && onBack != null) {
          backButton = _buildIconButton(
            context,
            icon: Icons.arrow_back,
            tooltip: 'Events',
            onPressed: onBack,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            isSquare: true,
          );
        }
        final isMobile = MediaQuery.of(context).size.width <= 600;
        Widget? addPhotoButton;
        if (entityType == EntityType.photo && onPressed != null) {
          addPhotoButton = ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? appTheme.primary,
              foregroundColor: foregroundColor ?? appTheme.iconLight,
              elevation: elevation ?? 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 8 : 10)),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20, 
                vertical: isMobile ? 8 : 12
              ),
              shadowColor: Colors.black.withOpacity(0.07),
            ),
            onPressed: onPressed,
            child: Tooltip(
              message: "Add photos",
              child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: isMobile ? 20 : 28,
                  color: appTheme.iconLight, 
                ),
                SizedBox(width: isMobile ? 8 : 12),
                if(!isMobile)
                  Text(
                  'Add photos',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (onPressed != null) {
          addPhotoButton = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? appTheme.primary,
            foregroundColor: foregroundColor ?? appTheme.iconLight,
            elevation: elevation ?? 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 8 : 10)),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20, 
                vertical: isMobile ? 8 : 12
              ),
            shadowColor: Colors.black.withOpacity(0.07),
          ),
          onPressed: onPressed,
            child: child ?? Icon(Icons.add, size: isMobile ? 20 : 28),
          );
        }
        return Positioned(
          left: 0,
          right: 0,
          bottom: isMobile ? 24 : 32,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (backButton != null) backButton else SizedBox(width: isMobile ? 48 : 56),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < centerButtons.length; i++) ...[
                        if (i > 0) SizedBox(width: isMobile ? 12 : 16),
                        centerButtons[i],
                      ],
                      if (addPhotoButton != null) ...[
                        if (centerButtons.isNotEmpty) SizedBox(width: isMobile ? 12 : 16),
                        addPhotoButton,
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
    bool isSquare = false,
  }) {
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isDesktop = MediaQuery.of(context).size.width > 600;
    
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation ?? 6,
          shape: isSquare
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 8 : 10))
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 8 : 10)),
          padding: isSquare
              ? EdgeInsets.all(isMobile ? 12 : 16)
              : EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20, 
                  vertical: isMobile ? 8 : 12
                ),
          shadowColor: Colors.black.withOpacity(0.07),
        ),
        onPressed: onPressed,
        child: isDesktop 
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    tooltip,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : Icon(icon, size: isMobile ? 20 : 28),
      ),
    );
  }
}

class EditButtonHandler {
  static void handleEditButton(BuildContext context, EntityType entityType) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final currentRoute = state.uiState.currentRoute;
    
    if (currentRoute.contains(EventViewScreen.route)) {
      _handleEventEdit(context, store, state);
    } else if (entityType == EntityType.photo) {
      _handlePhotoEdit(context, store, state);
    } else {
      createEntityByType(context: context, entityType: entityType);
    }
  }
  
  static void _handleEventEdit(BuildContext context, Store<AppState> store, AppState state) {
    final selectedEventId = state.eventUIState.selectedId;
    if (selectedEventId != null && selectedEventId.isNotEmpty) {
      final selectedEvent = state.eventState.map[selectedEventId];
      if (selectedEvent != null) {
        store.dispatch(EditEvent(event: selectedEvent));
      } else {
        store.dispatch(LoadEvent(eventId: selectedEventId));
        final completer = Completer<void>();
        store.dispatch(EditEvent(
          event: EventEntity(id: selectedEventId),
          completer: completer,
        ));
      }
    }
  }
  
  static void _handlePhotoEdit(BuildContext context, Store<AppState> store, AppState state) {
    if (!isAuthenticated(state)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoginDialogView(
          onLoginSuccess: () {
            Navigator.of(context).pop();
          },
        ),
      );
      return;
    }
    
    if (ProjectConfig.showEditPhotoDialog()) {
      final viewModel = PhotoEditVM.fromStore(store);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PhotoEditDialog(
          viewModel: viewModel,
          isEditMode: false,
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      createEntityByType(context: context, entityType: EntityType.photo);
    }
  }
  
  static EventEntity? getSelectedEventForPhotos(AppState state) {
    final selectionState = state.getUISelection(EntityType.photo);
    final filterEntityType = selectionState.filterEntityType;
    
    if (filterEntityType == EntityType.event && selectionState.filterEntityId != null) {
      return state.eventState.map[selectionState.filterEntityId] ?? 
             EventEntity(id: selectionState.filterEntityId);
    }
    
    if (state.uiState.currentRoute.contains(EventViewScreen.route)) {
      final selectedEventId = state.eventUIState.selectedId;
      if (selectedEventId != null && selectedEventId.isNotEmpty) {
        return state.eventState.map[selectedEventId] ?? 
               EventEntity(id: selectedEventId);
      }
    }
    
    return null;
  }
} 