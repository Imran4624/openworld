// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/admin/admin_screen.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/about_us.dart';
import 'package:flutter_boilerplate/ui/app/pending_approval_screen.dart';
import 'package:flutter_boilerplate/ui/app/routing_rules.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/ui/auth/welcome_event_screen.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_create.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_search_overview_screen.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_edit.dart';
import 'package:flutter_boilerplate/ui/settings/account_management_vm.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/maps_listing_view.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/app_title_bar.dart';
import 'package:flutter_boilerplate/ui/app/important_message_banner.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen_vm.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:redux/redux.dart';

// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/ui/payment/payment_screen.dart';
import 'package:flutter_boilerplate/ui/payment/payment_screen_vm.dart';
import 'package:flutter_boilerplate/ui/payment/edit/payment_edit_vm.dart';
import 'package:flutter_boilerplate/ui/payment/view/payment_view_vm.dart';

import 'package:flutter_boilerplate/ui/product/product_screen.dart';
import 'package:flutter_boilerplate/ui/product/product_screen_vm.dart';
import 'package:flutter_boilerplate/ui/product/edit/product_edit_vm.dart';
import 'package:flutter_boilerplate/ui/product/view/product_view_vm.dart';

import 'package:flutter_boilerplate/ui/photo/photo_screen.dart';
import 'package:flutter_boilerplate/ui/photo/photo_screen_vm.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:flutter_boilerplate/ui/photo/view/photo_view_vm.dart';

import 'package:flutter_boilerplate/ui/notification/notification_screen.dart';
import 'package:flutter_boilerplate/ui/notification/notification_screen_vm.dart';
import 'package:flutter_boilerplate/ui/notification/edit/notification_edit_vm.dart';
import 'package:flutter_boilerplate/ui/notification/view/notification_view_vm.dart';

import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/edit/profile_operation_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';

import 'package:flutter_boilerplate/ui/profile/profile_screen.dart';
import 'package:flutter_boilerplate/ui/profile/profile_screen_vm.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';

import 'package:flutter_boilerplate/ui/event/event_screen.dart';
import 'package:flutter_boilerplate/ui/event/event_screen_vm.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';

import 'package:flutter_boilerplate/ui/chat/chat_screen.dart';
import 'package:flutter_boilerplate/ui/chat/chat_screen_vm.dart';
import 'package:flutter_boilerplate/ui/chat/create/create_chat_vm.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_actions.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/app_border.dart';
import 'package:flutter_boilerplate/ui/app/blank_screen.dart';
import 'package:flutter_boilerplate/ui/app/confirm_email_vm.dart';
import 'package:flutter_boilerplate/ui/app/desktop_session_timeout.dart';
import 'package:flutter_boilerplate/ui/app/entity_top_filter.dart';
import 'package:flutter_boilerplate/ui/app/history_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/app/loading_indicator.dart';
import 'package:flutter_boilerplate/ui/app/menu_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/app/screen_imports.dart';
import 'package:flutter_boilerplate/ui/design/design_screen_vm.dart';
import 'package:flutter_boilerplate/ui/design/edit/design_edit_vm.dart';
import 'package:flutter_boilerplate/ui/design/view/design_view_vm.dart';
import 'package:flutter_boilerplate/ui/settings/device_settings_vm.dart';
import 'package:flutter_boilerplate/ui/settings/settings_screen_vm.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      final state = store.state;
      final uiState = state.uiState;
      final prefState = state.prefState;
      final subRoute = '/' + uiState.subRoute;
      String mainRoute = '/' + uiState.mainRoute;
      Widget screen = const BlankScreen();

      bool isGuestAccessAllowed(String route) {
        return !isAuthenticated(state) &&
            ProjectConfig.isAccessAllowedForGuestUser(route);
      }

      // This can happen if the user's permissions are changed
      if (isAuthenticated(state) &&
          state.companies.isEmpty &&
          isEmailVerified(state) &&
          !(ProjectConfig.appType == AppType.opw &&
              state.authState.isEmailLinkAuth)) {
        return Container(
          color: Theme.of(context).cardColor,
          child: const LoadingIndicator(),
        );
      } else if (isGuestAccessAllowed(ProjectConfig.defaultRouteForGuestUser)) {
        Widget? guestScreen = EntityScreens.getEntityScreenBuilderList(null,
            entityType: ProjectConfig.defaultEntityForGuestUser);
        if (guestScreen != null) {
          screen = guestScreen;
        }
      } else if (!isEmailVerified(state) &&
          state.companies.isEmpty &&
          !(ProjectConfig.appType == AppType.opw &&
              state.authState.isEmailLinkAuth)) {
        return const ConfirmEmailBuilder();
      } else if (state.authState.isArchived) {
        return const ApprovalPendingScreen();
      } else if (!state.authState.setProfileCompleted) {
        return const ProfileEditScreen();
      }

      bool showFilterSidebar = false;
      bool editingFilterEntity = false;
      if (prefState.isFilterVisible && uiState.filterEntityId != null) {
        showFilterSidebar = true;
        if (mainRoute == '/${uiState.filterEntityType}' &&
            subRoute == '/edit') {
          // Keep the current entity preview in place
          mainRoute = '/' + uiState.previousMainRoute;
          editingFilterEntity = true;
        }
      }

      switch (mainRoute) {
        // STARTER: main screen route - do not remove comment
        case PaymentScreen.route:
          screen = EntityScreens(
            entityType: EntityType.payment,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case ProductScreen.route:
          screen = EntityScreens(
            entityType: EntityType.product,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case PhotoScreen.route:
          screen = EntityScreens(
            entityType: EntityType.photo,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case NotificationScreen.route:
          screen = EntityScreens(
            entityType: EntityType.notification,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case ProfileOperationScreen.route:
          screen = EntityScreens(
            entityType: EntityType.profileOperation,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case ProfileScreen.route:
          screen = EntityScreens(
            entityType: EntityType.profile,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case EventScreen.route:
          screen = EntityScreens(
            entityType: EntityType.event,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case ChatScreen.route:
          screen = EntityScreens(
            entityType: EntityType.chat,
            editingFilterEntity: editingFilterEntity,
          );
          break;
        case AboutUs.route:
          screen = const AboutUs();
          break;
        case WelcomeEventScreen.route:
          screen = const WelcomeEventScreen();
          break;

        case AdminScreen.route:
          screen = const AdminScreen();
          break;
        case SettingsScreen.route:
          screen = SettingsScreens();
          break;
        case ApprovalPendingScreen.route:
          screen = const ApprovalPendingScreen();
          break;
        case DynamicFieldsCreate.route:
          screen = const DynamicFieldsCreate();
          break;
        case MapListingScreen.route:
          screen = MapListingScreen();
          break;
        case EditOverviewScreen.route:
          screen = const EditOverviewScreen();
          break;
        case SearchOverviewScreen.route:
          screen = const SearchOverviewScreen();
          break;
        case DashboardScreenBuilder.route:
          if (ProjectConfig.showDashboard &&
              state.userCompany.canViewDashboard) {
            screen = Row(
              children: <Widget>[
                const Expanded(
                  flex: 5,
                  child: DashboardScreenBuilder(),
                ),
                if (prefState.showHistory && ProjectConfig.showActivityLog)
                  const AppBorder(
                    isLeft: true,
                    child: HistoryDrawerBuilder(),
                  ),
              ],
            );
          } else {
            // Redirect to default entity if dashboard is not enabled
            RoutingRules.defaultEntityLoadingRouting();
            return Container(); // Return empty container as we're redirecting
          }
          break;
        default:
          if (mainRoute == '/login') {
            return const LoginScreen();
          }
          logError('main screen route $mainRoute not defined');
      }
      return PopScope(
        canPop: false,
        onPopInvoked: (_) async {
          final state = store.state;
          final historyList = state.historyList;
          final isEditing = state.uiState.isEditing;
          final index = isEditing ? 0 : 1;
          HistoryRecord? history;

          if (state.uiState.isPreviewing) {
            store.dispatch(PopPreviewStack());
          }

          for (int i = index; i < historyList.length; i++) {
            final item = historyList[i];
            if ([
              EntityType.dashboard,
              EntityType.settings,
            ].contains(item.entityType)) {
              history = item;
              break;
            } else if (item.id == null) {
              history = item;
            } else {
              final entity =
                  state.getEntityMap(item.entityType)![item.id] as BaseEntity?;
              if (entity == null || !entity.isActive) {
                continue;
              }

              history = item;
              break;
            }
          }

          if (!isEditing) {
            store.dispatch(PopLastHistory());
          }

          if (history == null) {
            RoutingRules.defaultEntityLoadingRouting();
          } else {
            switch (history.entityType) {
              case EntityType.dashboard:
                store.dispatch(ViewDashboard());
                break;
              case EntityType.settings:
                store.dispatch(ViewSettings(
                  section: history.id,
                  company: state.company,
                  user: state.user,
                  tabIndex: 0,
                ));
                break;
              default:
                if ((history.id ?? '').isEmpty) {
                  viewEntitiesByType(
                      entityType: history.entityType, page: history.page);
                } else {
                  viewEntityById(
                    entityId: history.id,
                    entityType: history.entityType,
                    showError: false,
                  );
                }
            }
          }
        },
        child: DesktopSessionTimeout(
          child: SafeArea(
            child: FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: Column(
                children: [
                  if (isWindows() &&
                      ProjectConfig.showEntityTopBar(
                          uiState.currentRoute, isMobile(context)))
                    const AppTitleBar(),
                  Expanded(
                    child: ImportantMessageBanner(
                      appLayout: prefState.appLayout,
                      suggestedLayout: AppLayout.desktop,
                      child: Row(children: <Widget>[
                        if (prefState.showMenu) const MenuDrawerBuilder(),
                        Expanded(
                            child: AppBorder(
                          isLeft: prefState.showMenu &&
                              (!state.isFullScreen || showFilterSidebar),
                          child: screen,
                        )),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class EntityScreens extends StatelessWidget {
  const EntityScreens({
    super.key,
    required this.entityType,
    this.editingFilterEntity,
  });

  final EntityType entityType;
  final bool? editingFilterEntity;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final prefState = state.prefState;
    final mainRoute = '/' + uiState.mainRoute;
    final subRoute = uiState.subRoute;
    final isFullScreen = state.isFullScreen;
    bool isPreviewShown = prefState.isPreviewVisible;

    if (subRoute != 'view' && subRoute.isNotEmpty) {
      isPreviewShown = true;
    }

    const previewFlex = 2;
    int listFlex = 3;

    if ((prefState.isModuleTable || mainRoute == '/task') && !isPreviewShown) {
      listFlex = 5;
    } else if (prefState.isMenuCollapsed) {
      listFlex += 1;
    }

    Widget? child;

    // TODO rmeove this once full width project editor is
    if (state.uiState.isEditing &&
        (state.uiState.currentRoute == EventScreen.route ||
            (state.uiState.currentRoute == EventEditScreen.route &&
                ProjectConfig.fullWidthEntities()
                    .contains(EntityType.event)))) {
      child = const EventEditScreen();
    } else if (isFullScreen &&
        uiState.currentRoute.contains(EventViewScreen.route)) {
      child = const EventViewScreen();
    } else if (isFullScreen &&
        uiState.currentRoute.contains(ProfileViewScreen.route)) {
      child = const ProfileViewScreen();
    } else if (isFullScreen) {
      switch (mainRoute) {
        case ApprovalPendingScreen.route:
          child = const ApprovalPendingScreen();
          break;
        case EventViewScreen.route:
          child = const EventViewScreen();
          break;
        case ProfileViewScreen.route:
          child = const ProfileViewScreen();
          break;
        default:
          switch (uiState.currentRoute) {
            case DashboardScreenBuilder.route:
              child = const DashboardScreenBuilder();
              break;
            case DesignEditScreen.route:
              child = const DesignEditScreen();
              break;
            case EventEditScreen.route:
              child = const EventEditScreen();
              break;
            case ProfileViewScreen.route:
              child = const ProfileViewScreen();
              break;
            case ProfileEditScreen.route:
              child = const ProfileEditScreen();
              break;
            case MessageScreen.route:
              child = const MessageScreenBuilder();
              break;
            default:
              logError('screen not defined in main_screen');
              break;
          }
      }
    } else if (subRoute == 'edit') {
      final editEntityType =
          editingFilterEntity! ? uiState.filterEntityType : entityType;
      switch (editEntityType) {
        // STARTER: edit screen - do not remove comment
        case EntityType.payment:
          child = PaymentEditScreen();
          break;
        case EntityType.product:
          child = const ProductEditScreen();
          break;
        case EntityType.photo:
          child = const PhotoEditScreen();
          break;
  
        case EntityType.notification:
          child = const NotificationEditScreen();
          break;
        case EntityType.profileOperation:
          child = const ProfileOperationEditScreen();
          break;
        case EntityType.profile:
          child = const ProfileEditScreen();
          break;
        case EntityType.event:
          child = const EventEditScreen();
          break;
        case EntityType.chat:
          child = const CreateChatScreen();
          break;
        default:
          printL(' Edit screen not defined for $entityType');
          break;
      }
    } else if (subRoute == 'search') {
      child = const SearchOverviewScreen();
    } else {
      final previewStack = uiState.previewStack;
      final previewEntityType =
          previewStack.isEmpty ? entityType : previewStack.last;
      final entityUIState = state.getUIState(previewEntityType)!;

      if ((entityUIState.selectedId ?? '').isEmpty ||
          !state
                  .getEntityMap(previewEntityType)!
                  .containsKey(entityUIState.selectedId!) &&
              entityUIState.selectedId! != getLoggedInUserId(store)) {
        child = const BlankScreen();
      } else {
        switch (previewEntityType) {
          case EntityType.user:
            child = const UserViewScreen();
            break;
          // STARTER: view screen - do not remove comment
          case EntityType.payment:
            child = PaymentViewScreen();
            break;
          case EntityType.product:
            child = const ProductViewScreen();
            break;
          case EntityType.photo:
            child = const PhotoViewScreen();
            break;
       
          case EntityType.notification:
            child = const NotificationViewScreen();
            break;
          case EntityType.profileOperation:
            child = const ProfileOperationViewScreen();
            break;
          case EntityType.profile:
            child = const ProfileViewScreen();
            break;
          case EntityType.event:
            child = const EventViewScreen();
            break;
          case EntityType.chat:
            child = const MessageScreenBuilder();
            // child = ChatViewScreen();
            break;
          default:
            printL(' View screen not defined for $previewEntityType');
        }
      }
    }

    Widget? leftFilterChild;
    Widget topFilterChild;

    if (uiState.filterEntityType != null) {
      if (prefState.isFilterVisible) {
        switch (uiState.filterEntityType) {
          case EntityType.user:
            leftFilterChild = const UserViewScreen(isFilter: true);
            break;
          case EntityType.event:
            leftFilterChild = const EventViewScreen(isFilter: true);
            break;
          case EntityType.design:
            leftFilterChild = const DesignViewScreen(isFilter: true);
            break;
          default:
            printL(
                'Error: filter view not implemented for ${uiState.filterEntityType}');
        }
      }
    }

    topFilterChild = EntityTopFilter(
      show: uiState.filterEntityType != null,
    );

    Widget? listWidget;
    if (!isFullScreen) {
      listWidget =
          getEntityScreenBuilderList(listWidget, entityType: entityType);
    }

    if (state.uiState.isEditing &&
        (state.uiState.currentRoute == EventScreen.route ||
            state.uiState.currentRoute == EventEditScreen.route)) {
      // Only show the edit screen in full width
      return AppBorder(child: child);
    }

    if (isFullScreen &&
        (uiState.currentRoute == EventViewScreen.route ||
            uiState.currentRoute == ProfileViewScreen.route)) {
      return AppBorder(child: child);
    }

    return Row(
      children: <Widget>[
        if (leftFilterChild != null)
          Expanded(
            flex: previewFlex,
            child: leftFilterChild,
          ),
        if (!isFullScreen)
          Expanded(
            flex: listFlex,
            child: ClipRRect(
              child: AppBorder(
                isLeft: leftFilterChild != null,
                child: prefState.isFilterVisible
                    ? listWidget
                    : (ProjectConfig.isTopbarScroollableForFullWidthEntities
                        ? CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: prefState.isViewerFullScreen(
                                        state.uiState.filterEntityType)
                                    ? SizedBox(
                                        height: 360,
                                        child: topFilterChild,
                                      )
                                    : topFilterChild,
                              ),
                              SliverFillRemaining(
                                hasScrollBody: true,
                                child: AppBorder(
                                  isTop: uiState.filterEntityType != null,
                                  child: listWidget,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              if (prefState.isViewerFullScreen(
                                  state.uiState.filterEntityType))
                                SizedBox(
                                  height: 360,
                                  child: topFilterChild,
                                )
                              else
                                topFilterChild,
                              Expanded(
                                child: AppBorder(
                                  isTop: uiState.filterEntityType != null,
                                  child: listWidget,
                                ),
                              )
                            ],
                          )),
              ),
            ),
          ),
        if ((prefState.isModuleList && mainRoute != '/task') || isPreviewShown)
          Expanded(
            flex: isFullScreen ? (listFlex + previewFlex) : previewFlex,
            child: AppBorder(
              isLeft: true,
              child: child,
            ),
          ),
        if (prefState.showHistory && ProjectConfig.showActivityLog)
          const AppBorder(
            isLeft: true,
            child: HistoryDrawerBuilder(),
          ),
      ],
    );
  }

  static Widget? getEntityScreenBuilderList(Widget? listWidget,
      {EntityType? entityType}) {
    switch (entityType) {
      // STARTER: list widget - do not remove comment
      case EntityType.payment:
        listWidget = PaymentScreenBuilder();
        break;
      case EntityType.dashboard:
        listWidget = const DashboardScreenBuilder();
        break;
      case EntityType.product:
        listWidget = const ProductScreenBuilder();
        break;
      case EntityType.photo:
        listWidget = const PhotoScreenBuilder();
        break;
      case EntityType.notification:
        listWidget = const NotificationScreenBuilder();
        break;
      case EntityType.profileOperation:
        listWidget = const ProfileOperationScreenBuilder();
        break;
      case EntityType.profile:
        listWidget = const ProfileScreenBuilder();
        break;
      case EntityType.event:
        listWidget = const EventScreenBuilder();
        break;
      case EntityType.chat:
        listWidget = const ChatScreenBuilder();
        break;
      case EntityType.auth:
        listWidget = const LoginScreen();
        break;
      default:
        logError('list widget not implemented for $entityType');
        break;
    }
    return listWidget;
  }
}

class SettingsScreens extends StatelessWidget {
  const SettingsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final prefState = state.prefState;

    Widget screen = const BlankScreen();

    switch (uiState.subRoute) {
      case kSettingsCompanyDetails:
        screen = const CompanyDetailsScreen();
        break;
      case kSettingsUserDetails:
        screen = const UserDetailsScreen();
        break;
      case kSettingsDeviceSettings:
        screen = const DeviceSettingsScreen();
        break;
      case kSettingsUserManagement:
        screen = const UserScreenBuilder();
        break;
      case kSettingsUserManagementView:
        screen = const UserViewScreen();
        break;
      case kSettingsUserManagementEdit:
        screen = const UserEditScreen();
        break;
      case kSettingsCustomDesigns:
        screen = const DesignScreenBuilder();
        break;
      case kSettingsCustomDesignsView:
        screen = const DesignViewScreen();
        break;
      case kSettingsCustomDesignsEdit:
        screen = const DesignEditScreen();
        break;
      case kSettingsAccountManagement:
        screen = const AccountManagementScreen();
        break;
      default:
        logError('main screen settings route ${uiState.subRoute} not defined');
    }

    return Row(children: <Widget>[
      if (!state.isFullScreen)
        const Expanded(
          flex: 2,
          child: SettingsScreenBuilder(),
        ),
      Expanded(
        flex: 3,
        child: AppBorder(
          isLeft: true,
          child: screen,
        ),
      ),
      if (prefState.showHistory && ProjectConfig.showActivityLog)
        const AppBorder(
          isLeft: true,
          child: HistoryDrawerBuilder(),
        ),
    ]);
  }
}
