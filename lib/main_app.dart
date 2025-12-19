// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/admin/admin_screen.dart';
import 'package:flutter_boilerplate/ui/app/about_us.dart';
import 'package:flutter_boilerplate/ui/app/pending_approval_screen.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/app/static_top_bar.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_create.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_search_overview_screen.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_edit.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';
import 'package:flutter_boilerplate/ui/event/event_screen.dart';
import 'package:flutter_boilerplate/ui/event/event_screen_vm.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/ui/settings/account_management_vm.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/maps_listing_view.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/ui/app/important_message_banner.dart';
import 'package:flutter_boilerplate/ui/app/window_manager.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen.dart';
import 'package:flutter_boilerplate/ui/chat/message_view/message_screen_vm.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:local_auth/local_auth.dart';
import 'package:redux/redux.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_analytics/firebase_analytics.dart';
// Stripe imports
import 'package:flutter_boilerplate/ui/payment/stripe/stripe_connect_screen.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/stripe_payment_screen.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/payment_method_manager_screen.dart';
import 'package:flutter_boilerplate/ui/payment/loopjam_stripe_upgrade_screen.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/company/company_selectors.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/app_builder.dart';
import 'package:flutter_boilerplate/ui/app/main_screen.dart';
import 'package:flutter_boilerplate/ui/app/screen_imports.dart';
import 'package:flutter_boilerplate/ui/app/web_session_timeout.dart';
import 'package:flutter_boilerplate/ui/app/web_socket_refresh.dart';
import 'package:flutter_boilerplate/ui/auth/init_screen.dart';
import 'package:flutter_boilerplate/ui/auth/lock_screen.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/ui/design/design_screen.dart';
import 'package:flutter_boilerplate/ui/design/design_screen_vm.dart';
import 'package:flutter_boilerplate/ui/design/edit/design_edit_vm.dart';
import 'package:flutter_boilerplate/ui/design/view/design_view_vm.dart';
import 'package:flutter_boilerplate/ui/settings/device_settings_vm.dart';
import 'package:flutter_boilerplate/ui/settings/settings_screen_vm.dart';
import 'package:flutter_boilerplate/ui/company/company_edit_screen.dart';
import 'package:flutter_boilerplate/ui/user/user_screen.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/ui/payment/payment_screen.dart';
import 'package:flutter_boilerplate/ui/payment/edit/payment_edit_vm.dart';
import 'package:flutter_boilerplate/ui/payment/view/payment_view_vm.dart';
import 'package:flutter_boilerplate/ui/payment/payment_screen_vm.dart';

import 'package:flutter_boilerplate/ui/product/product_screen.dart';
import 'package:flutter_boilerplate/ui/product/edit/product_edit_vm.dart';
import 'package:flutter_boilerplate/ui/product/view/product_view_vm.dart';
import 'package:flutter_boilerplate/ui/product/product_screen_vm.dart';

import 'package:flutter_boilerplate/ui/social/social_screen.dart';
import 'package:flutter_boilerplate/ui/social/edit/social_edit_vm.dart';
import 'package:flutter_boilerplate/ui/social/view/social_view_vm.dart';
import 'package:flutter_boilerplate/ui/social/social_screen_vm.dart';

import 'package:flutter_boilerplate/ui/photo/photo_screen.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:flutter_boilerplate/ui/photo/view/photo_view_vm.dart';
import 'package:flutter_boilerplate/ui/photo/photo_screen_vm.dart';

import 'package:flutter_boilerplate/ui/workout/workout_screen.dart';
import 'package:flutter_boilerplate/ui/workout/edit/workout_edit_vm.dart';
import 'package:flutter_boilerplate/ui/workout/view/workout_view_vm.dart';
import 'package:flutter_boilerplate/ui/workout/workout_screen_vm.dart';

import 'package:flutter_boilerplate/ui/notification/notification_screen.dart';
import 'package:flutter_boilerplate/ui/notification/edit/notification_edit_vm.dart';
import 'package:flutter_boilerplate/ui/notification/view/notification_view_vm.dart';
import 'package:flutter_boilerplate/ui/notification/notification_screen_vm.dart';

import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen.dart';
import 'package:flutter_boilerplate/ui/profile_operation/edit/profile_operation_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';
import 'package:flutter_boilerplate/ui/profile_operation/profile_operation_screen_vm.dart';

import 'package:flutter_boilerplate/ui/profile/profile_screen.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit_vm.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';
import 'package:flutter_boilerplate/data/models/app_version_model.dart';
import 'package:flutter_boilerplate/ui/app/system/update_dialog.dart';
import 'package:flutter_boilerplate/ui/profile/profile_screen_vm.dart';

import 'package:flutter_boilerplate/ui/chat/chat_screen.dart';
import 'package:flutter_boilerplate/ui/chat/create/create_chat_vm.dart';
import 'package:flutter_boilerplate/ui/chat/chat_screen_vm.dart';

import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';

import 'package:flutter_boilerplate/services/push_notifications/firebase_messaging_service.dart';

import 'package:flutter_boilerplate/data/models/models.dart';

import 'package:flutter_boilerplate/ui/auth/welcome_event_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

extension NavigatorKeyUtils on GlobalKey<NavigatorState> {
  AppLocalization? get localization {
    return AppLocalization.of(currentContext!);
  }

  Store<AppState> get store {
    return StoreProvider.of<AppState>(currentContext!);
  }
}

class FlutterBoilerplateApp extends StatefulWidget {
  const FlutterBoilerplateApp({Key? key, this.store}) : super(key: key);
  final Store<AppState>? store;

  @override
  FlutterBoilerplateAppState createState() => FlutterBoilerplateAppState();
}

class FlutterBoilerplateAppState extends State<FlutterBoilerplateApp> {
  bool _authenticated = false;
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();

  void _getCurrentVersionAndLog() async {
    try {
      final version = await getCurrentAppVersion();

      final completer = Completer<AppVersionEntity>();
      widget.store!.dispatch(GetUpdatedVersion(completer: completer));

      completer.future.then((appVersionEntity) {
        if (version != appVersionEntity.latest &&
            appVersionEntity.isUpdateRequired) {
          _showUpdateDialog(appVersionEntity);
        } else {
          logInfo('App is up to date');
        }
      }).catchError((error) {
        logError('Error getting app version data: $error');
      });
    } catch (e) {
      logError('Error getting app version: $e');
    }
  }

  void _showUpdateDialog(AppVersionEntity appVersionEntity) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UpdateDialog();
        },
      );
    });
  }

  Future<Null> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false,
        ),
      );
    } catch (e) {
      logError('Error in method:_authenticate detail: $e');
    }

    if (authenticated) {
      setState(() => _authenticated = true);
    }
  }

  // --- Generic entity view handler for web URL routing ---
  void handleEntityViewFromUrl(Store<AppState> store) {
    if (!isWeb() || !ProjectConfig.openEntityFromUrlEnabled) return;

    final path = WebUtils.browserRoute;
    final id = WebUtils.getUrlParameter('id');
    
    if (id == null || id.isEmpty || path == null || path.isEmpty) return;

    String routePath = path;
    if (path.contains('?')) {
      routePath = path.split('?')[0];
    }

    final entityViewRoutes = <String, EntityType>{
      EventViewScreen.route: EntityType.event,
      PhotoViewScreen.route: EntityType.photo,
    };

    final entityType = entityViewRoutes[routePath];
    if (entityType != null) {
      fetchAndViewEntity(store: store, entityType: entityType, entityId: id);
    }
  }

  void _handleUrlChange() {
    final store = widget.store!;
    handleEntityViewFromUrl(store);
  }

  @override
  void initState() {
    super.initState();
    if (ProjectConfig.showUpdateVersionDialog()) {
      _getCurrentVersionAndLog();
    }

    if (isWeb()) {
      WebUtils.warnChanges(widget.store);

      handleEntityViewFromUrl(widget.store!);

      WebUtils.addPopStateListener(_handleUrlChange);
    }

    Timer.periodic(
        const Duration(milliseconds: kMillisecondsToTimerRefreshData), (_) {
      final store = widget.store!;
      final state = store.state;

      if (!state.authState.isAuthenticated) {
        return;
      }

      if (!state.uiState.hasRecentActivity) {
        return;
      }

      final millisecondsSinceLastUpdate =
          DateTime.now().millisecondsSinceEpoch -
              state.userCompanyState.lastUpdated;

      if (millisecondsSinceLastUpdate > kMillisecondsToTimerRefreshData) {
        store.dispatch(const RefreshData());
      }
    });

    _initializeMessaging();
  }

  Future<void> _initializeMessaging() async {
    try {
      if (widget.store!.state.authState.email.isNotEmpty && mounted) {
        await _messagingService.initialize(context);
      }
    } catch (e) {
      logError('initializing messaging error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final state = widget.store!.state;
    widget.store!
        .dispatch(UpdateUserPreferences(appLayout: calculateLayout(context)));
    if (state.prefState.requireAuthentication && !_authenticated) {
      _authenticate();
    }

    final brightness = MediaQuery.of(context).platformBrightness;
    final enableDarkModeSystem = brightness == Brightness.dark;
    final store = widget.store!;
    final prefState = store.state.prefState;

    if (prefState.enableDarkModeSystem != enableDarkModeSystem) {
      store.dispatch(
          UpdateUserPreferences(enableDarkModeSystem: enableDarkModeSystem));
    }

    super.didChangeDependencies();
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    /*
    printL(' generateRoute: ${settings.name}, isInitial: ${settings.isInitialRoute}');
    printL(' pathname: ${html5.window.location.pathname} hash: ${html5.window.location.hash}, href: ${html5.window.location.href}');
    html5.window.history.replaceState(null, settings.name, '/#${settings.name}');
    widget.store.dispatch(UpdateCurrentRoute(settings.name));
    */
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute<dynamic>(builder: (_) => const LoginScreen());
      case '/stripe_connect':
        return MaterialPageRoute<dynamic>(builder: (_) => const StripeConnectScreen());
      case '/stripe_payment':
        return MaterialPageRoute<dynamic>(builder: (_) => const StripePaymentScreen());
      case '/payment_method_manager':
        return MaterialPageRoute<dynamic>(
            builder: (_) => const PaymentMethodManagerScreen());
      case '/loopjam_stripe_upgrade':
        final arguments = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute<dynamic>(
          builder: (_) => LoopjamStripeUpgradeScreen(
            feature: arguments?['feature'] ?? 'upgrade',
            description: arguments?['description'],
            adminStripeAccountId: arguments?['adminStripeAccountId'],
            amount: arguments?['amount'],
            priceId: arguments?['priceId'],
          ),
          settings: settings,
        );
      case '/company_edit':
        return MaterialPageRoute<dynamic>(
          builder: (_) => const CompanyEditScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const MainScreen());
    }
  }

  void _initTimeago() {
    final locale = localeSelector(widget.store!.state, twoLetter: true);
    if (locale == 'ar') {
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      timeago.setLocaleMessages('ar_short', timeago.ArMessages());
    } else if (locale == 'ca') {
      timeago.setLocaleMessages('ca', timeago.CaMessages());
      timeago.setLocaleMessages('ca_short', timeago.CaMessages());
    } else if (locale == 'cs') {
      timeago.setLocaleMessages('cs', timeago.CsMessages());
      timeago.setLocaleMessages('cs_short', timeago.CsMessages());
    } else if (locale == 'da') {
      timeago.setLocaleMessages('da', timeago.DaMessages());
      timeago.setLocaleMessages('da_short', timeago.DaMessages());
    } else if (locale == 'de') {
      timeago.setLocaleMessages('de', timeago.DeMessages());
      timeago.setLocaleMessages('de_short', timeago.DeMessages());
    } else if (locale == 'en') {
      timeago.setLocaleMessages('en', timeago.EnMessages());
      timeago.setLocaleMessages('en_short', timeago.EnMessages());
    } else if (locale == 'es') {
      timeago.setLocaleMessages('es', timeago.EsMessages());
      timeago.setLocaleMessages('es_short', timeago.EsMessages());
    } else if (locale == 'fa') {
      timeago.setLocaleMessages('fa', timeago.FaMessages());
    } else if (locale == 'fr') {
      timeago.setLocaleMessages('fr', timeago.FrMessages());
      timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
    } else if (locale == 'hu') {
      timeago.setLocaleMessages('hu', timeago.HuMessages());
      timeago.setLocaleMessages('hu_short', timeago.HuShortMessages());
    } else if (locale == 'it') {
      timeago.setLocaleMessages('it', timeago.ItMessages());
      timeago.setLocaleMessages('it_short', timeago.ItShortMessages());
    } else if (locale == 'ja') {
      timeago.setLocaleMessages('ja', timeago.JaMessages());
    } else if (locale == 'nb') {
      timeago.setLocaleMessages('nb', timeago.NbNoMessages());
      timeago.setLocaleMessages('nb_short', timeago.NbNoShortMessages());
    } else if (locale == 'nl') {
      timeago.setLocaleMessages('nl', timeago.NlMessages());
      timeago.setLocaleMessages('nl_short', timeago.NlShortMessages());
    } else if (locale == 'pl') {
      timeago.setLocaleMessages('pl', timeago.PlMessages());
    } else if (locale == 'pt') {
      timeago.setLocaleMessages('pt', timeago.PtBrMessages());
      timeago.setLocaleMessages('pt_short', timeago.PtBrShortMessages());
    } else if (locale == 'ro') {
      timeago.setLocaleMessages('ro', timeago.RoMessages());
      timeago.setLocaleMessages('ro_short', timeago.RoShortMessages());
    } else if (locale == 'ru') {
      timeago.setLocaleMessages('ru', timeago.RuMessages());
      timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
    } else if (locale == 'sv') {
      timeago.setLocaleMessages('sv', timeago.SvMessages());
      timeago.setLocaleMessages('sv_short', timeago.SvShortMessages());
    } else if (locale == 'th') {
      timeago.setLocaleMessages('th', timeago.ThMessages());
      timeago.setLocaleMessages('th_short', timeago.ThShortMessages());
    } else if (locale == 'zh') {
      timeago.setLocaleMessages('zh', timeago.ZhMessages());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store!,
      child: WebSessionTimeout(
        child: AppBuilder(builder: (context) {
          final store = widget.store!;
          final state = store.state;
          const pageTransitionsTheme = PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          });
          Intl.defaultLocale = localeSelector(state);
          final locale = AppLocalization.createLocale(localeSelector(state));
          _initTimeago();

          final textButtonTheme = TextButton.styleFrom(
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
            ),
          );

          final outlinedButtonTheme = OutlinedButton.styleFrom(
              foregroundColor:
                  AppTheme.getThemeColors(state.prefState.enableDarkMode).text,
              backgroundColor:
                  AppTheme.getThemeColors(state.prefState.enableDarkMode)
                      .transparent);

          return StyledToast(
            locale: locale,
            duration: const Duration(seconds: 4),
            backgroundColor:
                state.prefState.enableDarkMode ? Colors.white : Colors.black,
            textStyle: TextStyle(
              color: state.prefState.enableDarkMode
                  ? Colors.black87
                  : Colors.white,
            ),
            child: WebSocketRefresh(
              companyId: state.company.id,
              child: WindowManager(
                child: MaterialApp(
                  builder: (BuildContext context, Widget? child) {
                    final MediaQueryData data = MediaQuery.of(context);
                    Widget content = ProjectConfig.showTopBar(
                                state.uiState.currentRoute,
                                isGuestUser(state)) &&
                            !state.uiState.previousRoute.contains('_isPreview')
                        ? Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: child,
                              ),
                              Positioned(
                                top: isMobile(context) ? 0 : 20,
                                left: 0,
                                right: 0,
                                child: const StaticTopBar(),
                              ),
                            ],
                          )
                        : child!;

                    final sidePadding = Theme.of(context)
                        .extension<SidePaddingTheme>()
                        ?.sidePadding;
                    if (ProjectConfig.isSidePaddingEnabled &&
                        sidePadding != null) {
                      content = Container(
                        color: AppTheme.getThemeColors(
                                state.prefState.enableDarkMode)
                            .background,
                        child: Padding(
                          padding: sidePadding,
                          child: content,
                        ),
                      );
                    }

                    return MediaQuery(
                      data: data.copyWith(
                        textScaler:
                            TextScaler.linear(state.prefState.textScaleFactor),
                        alwaysUse24HourFormat:
                            state.company.settings.enableMilitaryTime ?? false,
                      ),
                      child: content,
                    );
                  },
                  scrollBehavior: state.prefState.enableTouchEvents &&
                          state.prefState.isDesktop
                      ? MyCustomScrollBehavior()
                      : null,
                  navigatorKey: navigatorKey,
                  supportedLocales: kLanguages
                      .map((String locale) =>
                          AppLocalization.createLocale(locale))
                      .toList(),
                  debugShowCheckedModeBanner: false,
                  //showPerformanceOverlay: true,
                  navigatorObservers: [
                    if (ProjectConfig.enableGoogleAnalytics)
                      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
                    // SentryNavigatorObserver(),
                  ],
                  localizationsDelegates: [
                    const AppLocalizationsDelegate(),
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate
                  ],
                  home: state.prefState.requireAuthentication && !_authenticated
                      ? LockScreen(onAuthenticatePressed: _authenticate)
                      : InitScreen(),
                  locale: locale,
                  /*
                  theme: state.prefState.enableDarkMode
                      ? ThemeData(
                          brightness: Brightness.dark,
                          colorSchemeSeed: accentColor,
                          useMaterial3: true)
                      : ThemeData(
                          brightness: Brightness.light,
                          colorSchemeSeed: accentColor,
                          useMaterial3: true),
                  */
                  theme: AppTheme.getTheme(
                    state.prefState.enableDarkMode,
                    accentColor: state.accentColor,
                    hasAccentColor: state.hasAccentColor,
                    pageTransitionsTheme: pageTransitionsTheme,
                    textButtonTheme: textButtonTheme,
                    outlinedButtonTheme: outlinedButtonTheme,
                    deviceWidth: MediaQuery.of(context).size.width,
                  ),
                  title: Config.APP_NAME,
                  onGenerateRoute: isMobile(context) ? null : generateRoute,
                  routes: isMobile(context)
                      ? {
                          LoginScreen.route: (context) => const LoginScreen(),
                          MainScreen.route: (context) => const MainScreen(),
                          DashboardScreenBuilder.route: (context) =>
                              ImportantMessageBanner(
                                suggestedLayout: AppLayout.mobile,
                                appLayout: state.prefState.appLayout,
                                child: const DashboardScreenBuilder(),
                              ),

                          AdminScreen.route: (context) => const AdminScreen(),

                          // STARTER: routes - do not remove comment
                          PaymentScreen.route: (context) =>
                              PaymentScreenBuilder(),
                          PaymentViewScreen.route: (context) =>
                              PaymentViewScreen(),
                          PaymentEditScreen.route: (context) =>
                              PaymentEditScreen(),

                          ProductScreen.route: (context) =>
                              const ProductScreenBuilder(),
                          ProductViewScreen.route: (context) =>
                              const ProductViewScreen(),
                          ProductEditScreen.route: (context) =>
                              const ProductEditScreen(),

                          SocialScreen.route: (context) =>
                              const SocialScreenBuilder(),
                          SocialViewScreen.route: (context) =>
                              const SocialViewScreen(),
                          SocialEditScreen.route: (context) =>
                              const SocialEditScreen(),

                          PhotoScreen.route: (context) =>
                              const PhotoScreenBuilder(),
                          PhotoViewScreen.route: (context) =>
                              const PhotoViewScreen(),
                          PhotoEditScreen.route: (context) =>
                              const PhotoEditScreen(),

                          WorkoutScreen.route: (context) =>
                              const WorkoutScreenBuilder(),
                          WorkoutViewScreen.route: (context) =>
                              const WorkoutViewScreen(),
                          WorkoutEditScreen.route: (context) =>
                              const WorkoutEditScreen(),

                          NotificationScreen.route: (context) =>
                              const NotificationScreenBuilder(),
                          NotificationViewScreen.route: (context) =>
                              const NotificationViewScreen(),
                          NotificationEditScreen.route: (context) =>
                              const NotificationEditScreen(),

                          ProfileOperationScreen.route: (context) =>
                              const ProfileOperationScreenBuilder(),
                          ProfileOperationViewScreen.route: (context) =>
                              const ProfileOperationViewScreen(),
                          ProfileOperationEditScreen.route: (context) =>
                              const ProfileOperationEditScreen(),

                          ProfileScreen.route: (context) =>
                              const ProfileScreenBuilder(),
                          AboutUs.route: (context) => const AboutUs(),
                          ApprovalPendingScreen.route: (context) =>
                              const ApprovalPendingScreen(),
                          ProfileViewScreen.route: (context) =>
                              const ProfileViewScreen(),
                          ProfileEditScreen.route: (context) =>
                              const ProfileEditScreen(),

                          EventScreen.route: (context) =>
                              const EventScreenBuilder(),
                          EventViewScreen.route: (context) =>
                              const EventViewScreen(),
                          EventEditScreen.route: (context) =>
                              const EventEditScreen(),

                          ChatScreen.route: (context) =>
                              const ChatScreenBuilder(),
                          DynamicFieldsCreate.route: (context) =>
                              const DynamicFieldsCreate(),
                          MapListingScreen.route: (context) =>
                              MapListingScreen(),
                          EditOverviewScreen.route: (context) =>
                              const EditOverviewScreen(),
                          SearchOverviewScreen.route: (context) =>
                              const SearchOverviewScreen(),
                          CreateChatScreen.route: (context) =>
                              const CreateChatScreen(),
                          MessageScreen.route: (context) =>
                              const MessageScreenBuilder(),

                          DesignScreen.route: (context) =>
                              const DesignScreenBuilder(),
                          DesignViewScreen.route: (context) =>
                              const DesignViewScreen(),
                          DesignEditScreen.route: (context) =>
                              const DesignEditScreen(),
                          UserScreen.route: (context) =>
                              const UserScreenBuilder(),
                          UserViewScreen.route: (context) =>
                              const UserViewScreen(),
                          UserEditScreen.route: (context) =>
                              const UserEditScreen(),
                          SettingsScreen.route: (context) =>
                              const SettingsScreenBuilder(),
                          CompanyDetailsScreen.route: (context) =>
                              const CompanyDetailsScreen(),
                          CompanyEditScreen.route: (context) =>
                              const CompanyEditScreen(),
                          UserDetailsScreen.route: (context) =>
                              const UserDetailsScreen(),
                          DeviceSettingsScreen.route: (context) =>
                              const DeviceSettingsScreen(),
                          AccountManagementScreen.route: (context) =>
                              const AccountManagementScreen(),
                          WelcomeEventScreen.route: (context) =>
                              const WelcomeEventScreen(),
                          // Stripe routes
                          StripeConnectScreen.route: (context) =>
                              const StripeConnectScreen(),
                          StripePaymentScreen.route: (context) =>
                              const StripePaymentScreen(),
                          PaymentMethodManagerScreen.route: (context) =>
                              const PaymentMethodManagerScreen(),
                          LoopjamStripeUpgradeScreen.route: (context) =>
                              const LoopjamStripeUpgradeScreen(
                                  feature: 'upgrade'),
                        }
                      : {},
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
